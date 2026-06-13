import type { FastifyInstance } from "fastify";
import { env } from "../lib/env.js";
import { findCallByProviderId, getActiveAgent, listAgentStudio } from "../lib/db.js";
import { compileAgentInstructions } from "../domain/agentCompiler.js";
import { toOpenAITools } from "../domain/toolRegistry.js";

export async function mediaStreamRoutes(app: FastifyInstance) {
  app.get("/api/media-stream", { websocket: true }, (connection, req) => {
    app.log.info("Twilio voice media stream connection established");

    let streamSid: string | null = null;
    let callSid: string | null = null;
    let openAiWs: any = null;

    connection.socket.on("message", async (data: string) => {
      try {
        const message = JSON.parse(data);

        switch (message.event) {
          case "connected":
            app.log.info("Twilio media stream connected");
            break;

          case "start":
            streamSid = message.start.streamSid;
            callSid = message.start.callSid;
            app.log.info(`Twilio media stream started for CallSid: ${callSid}, StreamSid: ${streamSid}`);

            // 1. Resolve call, agent, and compiled instructions
            if (callSid) {
              const call = await findCallByProviderId(callSid);
              if (call && call.accountId) {
                const agent = await getActiveAgent(call.accountId);
                if (agent) {
                  const studio = await listAgentStudio(call.accountId, agent.id);
                  const instructions = compileAgentInstructions({
                    agent,
                    scenarios: studio.scenarios,
                    scripts: studio.scripts
                  });

                  // 2. Open connection to OpenAI Realtime API
                  const wsClass = (globalThis as any).WebSocket;
                  if (!wsClass) {
                    app.log.error("Global WebSocket constructor not found in Node.js");
                    return;
                  }

                  const openAiUrl = `wss://api.openai.com/v1/realtime?model=${env.OPENAI_REALTIME_MODEL}`;
                  app.log.info(`Connecting to OpenAI Realtime at: ${openAiUrl}`);

                  // OpenAI Realtime requires custom authorization headers.
                  // Fastify/ws clients support passing custom headers via options.
                  openAiWs = new wsClass(openAiUrl, {
                    headers: {
                      Authorization: `Bearer ${env.OPENAI_API_KEY}`,
                      "OpenAI-Beta": "realtime=v1"
                    }
                  });

                  openAiWs.addEventListener("open", () => {
                    app.log.info("Connected to OpenAI Realtime API");

                    // 3. Configure OpenAI Session
                    const sessionConfig = {
                      type: "session.update",
                      session: {
                        instructions,
                        voice: agent.voice || "alloy",
                        input_audio_format: "g711_ulaw",
                        output_audio_format: "g711_ulaw",
                        modalities: ["audio", "text"],
                        tools: toOpenAITools(),
                        tool_choice: "auto"
                      }
                    };
                    openAiWs.send(JSON.stringify(sessionConfig));
                  });

                  openAiWs.addEventListener("message", (event: any) => {
                    try {
                      const response = JSON.parse(event.data);

                      // Pipe audio delta back to Twilio
                      if (response.type === "response.audio.delta" && response.delta) {
                        connection.socket.send(
                          JSON.stringify({
                            event: "media",
                            streamSid,
                            media: {
                              payload: response.delta
                            }
                          })
                        );
                      }

                      // Log tool/function execution calls
                      if (response.type === "response.function_call_arguments.done") {
                        app.log.info(`OpenAI requested tool execution: ${response.name} (${response.call_id})`);
                      }
                    } catch (err) {
                      app.log.error(`Error parsing OpenAI message: ${err}`);
                    }
                  });

                  openAiWs.addEventListener("close", () => {
                    app.log.info("OpenAI Realtime connection closed");
                  });

                  openAiWs.addEventListener("error", (err: any) => {
                    app.log.error(`OpenAI Realtime error: ${err.message || err}`);
                  });
                }
              }
            }
            break;

          case "media":
            // 4. Pipe raw mulaw audio chunks from Twilio to OpenAI
            if (openAiWs && openAiWs.readyState === 1 && message.media && message.media.payload) {
              const audioAppend = {
                type: "input_audio_buffer.append",
                audio: message.media.payload
              };
              openAiWs.send(JSON.stringify(audioAppend));
            }
            break;

          case "stop":
            app.log.info("Twilio media stream stop request received");
            if (openAiWs) {
              openAiWs.close();
            }
            break;
        }
      } catch (err) {
        app.log.error(`Error parsing Twilio media stream payload: ${err}`);
      }
    });

    connection.socket.on("close", () => {
      app.log.info("Twilio media stream connection closed");
      if (openAiWs) {
        openAiWs.close();
      }
    });
  });
}
