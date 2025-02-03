---
layout: distill
title: RepoChat Arena
description: A Live Benchmark for AI Software Engineers
giscus_comments: true
date: 2025-02-01
featured: true
thumbnail: assets/img/blog/copilot_arena/leaderboard_pfp.png
authors:
  - name: Wei-Lin Chiang
    url: "https://infwinston.github.io/"
---

## Introduction

An integral part of using LLMs as part of a user's coding workflow is navigating and understanding complex code bases. We launched **RepoChat** – a new arena that answers code-related queries using a user-provided github repository link. 

RepoChat lets models automatically retrieve relevant files from the given GitHub repository. It can resolve issues, review PRs, implement code, as well as answer higher level questions about the repositories–all without requiring users to provide extensive context. 

You can view our video demo [here](https://x.com/lmarena_ai/status/1861869943505182862). 

<img src="/assets/img/blog/repochat-arena/simplified_pipeline.png" alt="Demo of RepoChat" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 1. A simplified graphical representation of the retriever -> responder pipeline in RepoChat.</p>

So far, RepoChat has collected around **20k battles** and over **4k votes**. All statistics calculated in this blog uses conversations and votes collected between **November 30, 2024** to **January 31, 2025** inclusive.

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">Metric</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Value</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;"># of conversations</td>
      <td style="padding: 8px; border: 1px solid lightgray; text-align: right;">10,830</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;"># of votes</td>
      <td style="padding: 8px; border: 1px solid lightgray; text-align: right;">4,069</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;"># of unique GitHub links (in convos)</td>
      <td style="padding: 8px; border: 1px solid lightgray; text-align: right;">4,266</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;"># of unique GitHub links (in votes)</td>
      <td style="padding: 8px; border: 1px solid lightgray; text-align: right;">2,058</td>
    </tr>
  </tbody>
</table>
</div>
<p style="color:gray; text-align: center;">Table 1.  Number of conversations, votes, and unique GitHub links logged from 11/30/2024 - 01/29/2025.UPDATE</p>

In this blog we will cover:
- [**Initial Results**](#initial-leaderboards): our preliminary results for the RepoChat leaderboards
- [**How do people use RepoChat**](#how-do-people-use-repochat): an analysis of the distribution of github links and user queries' category, length, language, etc.  
- [**How does it work**](#how-does-it-work): a more technical and detailed explanation of the RepoChat pipeline and implementation
- [**Further Analysis and Results**](#further-analysis-and-results): retriever and style controlled leaderboards, and other analysis of model rankings. 

## Initial Leaderboards
Since there are two separate components (retriever and responder), we produce two separate leaderboards. Jump to [here](#leaderboard-calculation) for details about how the leaderboards are calculated, and [here](#style-control) for more leaderboards. 

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">confidence interval</th>
      <th style="padding: 8px; border: 1px solid lightgray;">rating (rounded)</th>
      <th style="padding: 8px; border: 1px solid lightgray;">num votes</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;">GPT 4o (20241120)</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+11.74 | -11.83</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1090.08</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1748</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;">DeepSeek V3</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+23.56 | -21.07</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1026.15</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">425</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;">Gemini 2.0 Flash Exp</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+14.22 | -14.42</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1006.89</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1289</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;">Claude 3.5 Sonnet (20241022)</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+13.23 | -11.42</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1001.4</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1828</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;">GPT 4o mini (20240718)</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+32.86 | -39.12</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">989.17</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">271</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;">Gemini 1.5 Pro</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+16.58 | -15.75</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">971.93</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">978</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;">LLaMA 3.1 405B Instruct FP8</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+18.8 | -19.02</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">914.06</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">925</td>
    </tr>
  </tbody>
</table>
</div>
<p style="color:gray; text-align: center;">Table 2. Elo ratings of six popular models based on 4K votes collected between November 30, 2024 to January 31, 2025. This ranks the models for generating model response</p>

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">confidence interval</th>
      <th style="padding: 8px; border: 1px solid lightgray;">rating (rounded)</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;">gemini-1.5-flash-002</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+15.14 | -13.57</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1008.2</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;">GPT 4o mini (20240718)</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+13.57 | -15.14</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">991.8</td>
    </tr>
  </tbody>
</table>
</div>
<p style="color:gray; text-align: center;">Table 3. Elo ratings of the two retrievers based on 4K votes collected between November 30, 2024 to January 31, 2025. This ranks the models for retrieving relevant files.</p>

## How do people use RepoChat?
**What types of Github links do users input?** RepoChat features a wide range of GitHub links, including repositories, issues, pull requests, and others. We find that the vast majority (almost 80%) of user input links are repository links, followed by issues and branches. 
<img src="/assets/img/blog/repochat_arena/PIC_pie_chart.png" alt="GitHub Link Categories" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 2. Breakdown of the GitHub link categories in RepoChat by percentage.</p>

**What programming languages do people ask about?** The following statistic is calculated based on the file extensions of the relevant files. This serves as an indicator of the programming languages users are most frequently inquiring about/coding in. The abundance of markdown files is primarily due to README files, which are often extracted due to containing critical descriptions and instructions for the repository.
<img src="/assets/img/blog/repochat_arena/PIC_file_type.png" alt="Programming Language Breakdown" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 3. Breakdown of retrieved file types by percentage.</p>

**What natural languages do the user queries contain?** Most of our votes contain user queries in English, followed by Russian and Chinese. 
<img src="/assets/img/blog/repochat_arena/PIC_natural_language.png" alt="Natural Language Breakdown" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 4. Breakdown of user query’s language by count.</p>

**How long are the user queries?** The user query length varies significantly, ranging from a minimum of 1 token to a maximum of 1,406,325 tokens, with a median of 19 tokens. Short-length queries mostly consist of prose requesting implementations or instructions, whereas longer queries often include extensive code blocks. 
<img src="/assets/img/blog/repochat_arena/PIC_query_len.png" alt="Query Length Distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 5. Distribution of user query length.</p>

**How long are the retrieved file contexts?** The distribution of retrieved file content is more stable, with a median of 9,257, an average of 12,881, and a maximum of 126,329 tokens, with the occasional empty retrieval. 
<img src="/assets/img/blog/repochat_arena/PIC_context_len.png" alt="Retrieved Context Length Distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 6. Distribution of retrieved file context length.</p>

**What are the most common uyser query types?**
- **High level questions about a repository:**
    - [https://github.com/lllyasviel/ControlNet](https://github.com/lllyasviel/ControlNet)<br>Explain
    - [https://github.com/remix-run/react-router](https://github.com/remix-run/react-router)<br>How to use this repo?
    - [https://github.com/Mrjoulin/ITMOLabs](https://github.com/Mrjoulin/ITMOLabs)<br>What is this repository about? How I can use it? What main languages and frameworks are used here?
- **Specific how-to questions:**
    - [https://github.com/leecig/OpenDevin/tree/main](https://github.com/leecig/OpenDevin/tree/main)<br>How do I use a local LLM being ran by LMStudio?
    - [https://github.com/notfiz/de3u](https://github.com/notfiz/de3u)<br>,summary.,How do I install this on Linux (Mint 22)? Be thorough.
    - [https://github.com/ohmyzsh/ohmyzsh/](https://github.com/ohmyzsh/ohmyzsh/)<br>Tell me, what it means and how to use the `kubectx_mapping` in the plugins/kubectx?  

- **Implementation requests:**
    - [https://github.com/dipu-bd/lightnovel-crawler](https://github.com/dipu-bd/lightnovel-crawler)<br>Write a Python script that fetches the top 10 highest-rated light novels from Anilist and then downloads all of their volumes in .epub format using this.
    - [https://github.com/varungodbole/prompt-tuning-playbook](https://github.com/varungodbole/prompt-tuning-playbook)<br>Help me design a system prompt to extract metrics from financial reports.
    - [https://github.com/ocaml/ocaml](https://github.com/ocaml/ocaml)<br>If I wanted to implement partial escape analysis, which of the OCaml Intermediate Representations would be best suited and where should I make the change?

- **Specific explanation requests:**
    - [https://github.com/ant-design/ant-design](https://github.com/ant-design/ant-design)<br>Why does Ant Design 5 decide to use CSS-in-JS?
    - [https://github.com/hhy-huang/GraphJudger](https://github.com/hhy-huang/GraphJudger)<br>How is the graph knowledge graph in this repository generated?
    - [https://github.com/celzero/rethink-app](https://github.com/celzero/rethink-app)<br>How are connection/network changes handled?

- **Requests for solving an issue:**
    - [https://github.com/HALF111/calibration_CDS](https://github.com/HALF111/calibration_CDS)<br>Solve this issue.
    - [https://github.com/pyca/cryptography/issues/7189](https://github.com/pyca/cryptography/issues/7189)<br>Using asyncssh can fix the immediate loading error for the PEM file, but when accessing `cert.extensions` it still errors out with the same ordering issue.
    - [https://github.com/rust-lang/rfcs/issues/1856](https://github.com/rust-lang/rfcs/issues/1856)<br>In 100 words or less, what is the easiest approach to resolving this issue (without giving up)?

- **Requests for reviewing a PR:**
    - [https://github.com/fairy-stockfish/Fairy-Stockfish/pull/758](https://github.com/fairy-stockfish/Fairy-Stockfish/pull/758)<br>Review this PR.
    - [https://github.com/ggerganov/llama.cpp/pull/10455](https://github.com/ggerganov/llama.cpp/pull/10455)<br>What type of speculative decoding is supported with this pull request?
    - [https://github.com/pandas-dev/pandas/pull/56061](https://github.com/pandas-dev/pandas/pull/56061)<br>Explain the optimization.

- **Queries with code snippets, requests for modifying existing code, and debugging:** (click the arrow to expand the full query)
    - [https://github.com/julien-blanchon/arxflix/tree/feat/groq_whisper](https://github.com/julien-blanchon/arxflix/tree/feat/groq_whisper)<br>
      <details>
        <summary>when using the gradio interface, the stage of generating video get me this error :</summary> 
        INFO:__main__:Generated assets successfully.
        INFO:backend.main:Generating video to output.mp4 from tmpmpc_r1vm
        Free port: 55427
        Exposed directory /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm
        Starting up http-server, serving /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm

        http-server version: 14.1.1

        http-server settings: 
        CORS: true
        Cache: 3600 seconds
        Connection Timeout: 120 seconds
        Directory Listings: visible
        AutoIndex: visible
        Serve GZIP Files: false
        Serve Brotli Files: false
        Default File Extension: none

        Available on:
        http://localhost:55427
        Hit CTRL-C to stop the server

        INFO:backend.utils.generate_video:Exposed directory /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm
        INFO:backend.utils.generate_video:Generating video to /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm/output.mp4
        (node:93666) ExperimentalWarning: CommonJS module /opt/homebrew/lib/node_modules/npm/node_modules/debug/src/node.js is loading ES Module /opt/homebrew/lib/node_modules/npm/node_modules/supports-color/index.js using require().
        Support for loading ES Module in require() is an experimental feature and might change at any time
        (Use `node --trace-warnings ...` to show where the warning was created)
        Bundled code       ━━━━━━━━━━━━━━━━━━ 550ms
        [Fri Dec 06 2024 00:02:39 GMT+0100 (Central European Standard Time)]  "GET /audio.wav" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/131.0.6778.87 Safari/537.36"
        (node:93654) [DEP0066] DeprecationWarning: OutgoingMessage.prototype._headers is deprecated
        (Use `node --trace-deprecation ...` to show where the warning was created)
        Composition        Arxflix
        Codec              h264
        Output             /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm/output.mp4
        Concurrency        1x
        Rendering frames   ━━━━━━━━━━━━━━━━━━    0/2353
        Encoding video     ━━━━━━━━━━━━━━━━━━    0/2353[Fri Dec 06 2024 00:02:39 GMT+0100 (Central European Standard Time)]  "GET /subtitles.srt" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/131.0.6778.87 Safari/537.36"
        [Fri Dec 06 2024 00:02:39 GMT+0100 (Central European Standard Time)]  "GET /rich.json" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/131.0.6778.87 Safari/537.36"
        node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:187  Error: No "src" prop was passed to <Img>.
            at ImgRefForwarding (http://localhost:3000/bundle.js:26884:15)
            at Nh (http://localhost:3000/bundle.js:25838:137)
            at Yi (http://localhost:3000/bundle.js:25870:57)
            at Vk (http://localhost:3000/bundle.js:25971:275)
            at Uk (http://localhost:3000/bundle.js:25957:389)
            at Tk (http://localhost:3000/bundle.js:25957:320)
            at Ik (http://localhost:3000/bundle.js:25957:180)
            at Nk (http://localhost:3000/bundle.js:25948:88)
            at Gk (http://localhost:3000/bundle.js:25945:429)
            at J (http://localhost:3000/bundle.js:34117:203)

        An error occurred while rendering frame 0:
        Error  No "src" prop was passed to <Img>.

        at node_modules/.pnpm/remotion@4.0.171_react-dom@18.3.1_react@18.3.1__react@18.3.1/node_modules/remotion/dist/cjs/Img.js:19
        17 │ const { delayPlayback } = (0, use_buffer_state_js_1.useBufferState)();
        18 │ const sequenceContext = (0, react_1.useContext)(SequenceContext_js_1.SequenceContext);
        19 │ if (!src) {
        20 │     throw new Error('No "src" prop was passed to <Img>.');
        21 │ }
        22 │ (0, react_1.useImperativeHandle)(ref, () => {

        at Nh (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:159)
        at Yi (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:191)
        at Vk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:292)
        at Uk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:278)
        at Tk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:278)
        at Ik (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:278)
        at Nk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:269)
        at Gk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:266)
        at J (node_modules/.pnpm/scheduler@0.23.2/node_modules/scheduler/cjs/scheduler.production.min.js:12)
        at R (node_modules/.pnpm/scheduler@0.23.2/node_modules/scheduler/cjs/scheduler.production.min.js:13)
        INFO:backend.utils.generate_video:Generated video to /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm/output.mp4
        http-server stopped.
        INFO:__main__:Generated video successfully.
        ^CKeyboard interruption in main thread... closing server.
      </details>
    - [https://github.com/feathers-studio/telegraf-docs](https://github.com/feathers-studio/telegraf-docs)<br>
      <details>
        <summary>bot.js:</summary> 

        ```
        require("dotenv").config();

        const { Telegraf, session } = require("telegraf");
        const { registerCommands } = require("./commands");
        const { registerHears } = require("./hears");
        const { registerScenes } = require("./scenes");
        const sequelize = require("./database");
        const User = require("./models/user");
        const { t, i18next } = require("./i18n");
        const Plans = require("./models/plans");

        // sync database
        (async () => {
        try {
            await sequelize.sync({ force: true });
            console.log("database synchronized successfully.");

            const bot = new Telegraf(process.env.BOT_TOKEN);

            const defaultPlan = await Plans.findOne({ where: { isDefault: true } });
            if (!defaultPlan) {
            await Plans.create({
                name: "atom",
                isDefault: true,
                price: 0,
            });
            console.log("default plan created.");
            }

            // telegraf.js sessions
            bot.use(
            session({
                defaultSession: () => ({ counter: 0, userName: "" }), // Initialize session variables
            })
            );
            // user check/creation middleware
            bot.use(async (ctx, next) => {
            const telegramId = ctx.from.id;
            try {
                let user = await User.findOne({ where: { telegramId } });
                if (!user) {
                user = await User.create({
                    name: ctx.from.first_name || "unknown",
                    telegramId: telegramId,
                });
                console.log(
                    `new user created: ${user.name} (id: ${user.telegramId})`
                );
                }

                ctx.session.isAuthorized = true;
                ctx.session.user = user;
                ctx.session.language = user.language || "ru";

                i18next.changeLanguage(ctx.session.language);
                return next();
            } catch (error) {
                console.error("error during user check/creation:", error);
                return ctx.reply(t("error_user_creation"));
            }
            });

            // register commands, hears, and scenes
            registerCommands(bot);
            registerHears(bot);
            registerScenes(bot);

            // start the bot
            bot.launch();
            console.log("bot is running.");

            // enable graceful stop
            process.once("SIGINT", () => bot.stop("SIGINT"));
            process.once("SIGTERM", () => bot.stop("SIGTERM"));
        } catch (error) {
            console.error("error initializing bot:", error);
        }
        })();
        ```

        don't do check in database at every message, but have a kind of cache in telegraf.js session

      </details>
    - [https://github.com/sktime/sktime](https://github.com/sktime/sktime)<br>
      <details>
        <summary>debug the code as a professional would do. The code is for running in jupyter.</summary> 

        ```
        import pandas as pd
        import numpy as np
        from sktime.forecasting.model_selection import (
            ForecastingOptunaSearchCV,
            ExpandingWindowSplitter,
            temporal_train_test_split
        )
        from sktime.forecasting.base import ForecastingHorizon
        from sktime.performance_metrics.forecasting import MeanAbsolutePercentageError
        from sktime.forecasting.compose import TransformedTargetForecaster
        from sktime.forecasting.statsforecast import (
            StatsForecastMSTL,
            StatsForecastAutoETS,
            StatsForecastAutoARIMA,
            StatsForecastAutoTheta
        )
        from sktime.transformations.series.detrend import Detrender
        from sktime.transformations.series.deseasonalize import Deseasonalizer
        import optuna
        import warnings

        warnings.filterwarnings('ignore')

        # Load your time series data
        # Ensure 'pivot_table' is defined and contains the 'PAN4_PIBPMG4' series
        y = pivot_table['PAN4_PIBPMG4']

        # Split the data into train and test sets
        y_train, y_test = temporal_train_test_split(y, test_size=8)

        # Define the forecasting horizon
        fh = ForecastingHorizon(np.arange(1, 9), is_relative=True)

        # Set up cross-validation with an expanding window splitter
        cv = ExpandingWindowSplitter(fh=fh, initial_window=len(y_train) - 8)

        # Define the parameter space for tuning
        param_distributions = {
            'forecaster__season_length': optuna.distributions.CategoricalDistribution([(4,), (8,)]),
            'forecaster__trend_forecaster': optuna.distributions.CategoricalDistribution([
                StatsForecastAutoETS(model="ZZZ"),
                StatsForecastAutoARIMA(seasonal=True),
                StatsForecastAutoTheta()
            ]),
            'forecaster__stl_kwargs': {
                'robust': optuna.distributions.CategoricalDistribution([True, False]),
                'period': optuna.distributions.IntUniformDistribution(4, 8)
            }
        }

        # Initialize the MSTL forecaster
        mstl_forecaster = StatsForecastMSTL()

        # Create a pipeline with optional transformations
        forecaster = TransformedTargetForecaster(steps=[
            ("detrender", Detrender()),
            ("deseasonalizer", Deseasonalizer()),
            ("mstl_forecaster", mstl_forecaster)
        ])

        # Set up the OptunaSearchCV
        optuna_search = ForecastingOptunaSearchCV(
            forecaster=forecaster,
            cv=cv,
            param_distributions=param_distributions,
            scoring=MeanAbsolutePercentageError(symmetric=True),
            n_trials=100,
            random_state=42
        )

        # Fit the model
        optuna_search.fit(y_train)

        # Predict
        y_pred = optuna_search.predict(fh)

        # Evaluate
        mape = MeanAbsolutePercentageError(symmetric=True)
        final_mape = mape(y_test, y_pred)
        print(f"Final sMAPE: {final_mape:.2f}")

        # Plot results
        import matplotlib.pyplot as plt

        plt.figure(figsize=(15, 7))
        plt.plot(y_train.index, y_train.values, label='Training Data', color='blue')
        plt.plot(y_test.index, y_test.values, label='Test Data', color='green')
        plt.plot(y_pred.index, y_pred.values, label='Predictions', color='red', linestyle='--')
        plt.title('MSTL Forecast Results with Optuna Optimization')
        plt.legend()
        plt.grid(True)
        plt.show()

        # Save the best model
        from joblib import dump
        dump(optuna_search.best_forecaster_, 'best_mstl_model_optuna.joblib')
        print("\nBest model saved as 'best_mstl_model_optuna.joblib'")

        # Print additional optimization results
        print("\nOptimization Results:")
        print("="*50)
        print(f"Number of completed trials: {len(optuna_search.cv_results_)}")
        print(f"Best trial number: {optuna_search.best_index_}")
        print(f"Best sMAPE achieved during optimization: {optuna_search.best_score_:.2f}")

        # Print best parameters
        print("\nBest Parameters Found:")
        print("="*50)
        for param, value in optuna_search.best_params_.items():
            print(f"{param}: {value}")
        ```
      </details>
  
## How Does It Work?

Each generated answer is the collaborative effort between two separate LLM models. The **retriever model** extracts the relevant files from the github repository according to the given user input. The extracted file contents are then concatenated together with the user query and used as a prompt for the **responder model**, which then generates the response.
<img src="/assets/img/blog/repochat_arena/PIC_complete_pipeline.png" alt="RepoChat full pipeline" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 7. Breakdown of the GitHub link categories in RepoChat by percentage.</p>

### File Retrieval
We select two models as retrievers: `gemini-1.5-flash-002` and `gpt-4o-mini`.
 
When a valid GitHub link is provided, the repository is cloned, and its file structure is extracted and formatted in an indented layout. The retriever model is then prompted to strategically identify files from the file structure that are potentially useful for answering the query. It then outputs these files in decreasing order of relevance and a specified markdown format. 

<details>
<summary>Click to view retriever prompt</summary> 
The following files are found in the repository:<br>
{file structure}<br>
Please provide a list of files that you would like to search for answering the user query. <br>
Enclose the file paths in a list in a markdown code block as shown below:<br>
```<br>
1. [[ filepath_1 ]]\n<br>
2. [[ filepath_2 ]]\n<br>
3. [[ filepath_3 ]]\n<br>
...<br>
```<br>
Think step-by-step and strategically reason about the files you choose to maximize the chances of finding the answer to the query. Only pick the files that are most likely to contain the information you are looking for in decreasing order of relevance. Once you have selected the files, please submit your response in the appropriate format mentioned above (markdown numbered list in a markdown code block). The filepath within [[ and ]] should contain the complete path of the file in the repository.<br>
{query}
</details>


### Model Response Generation
The contents of relevant files are extracted, concatenated with the user query, and provided to the responding LLM as a prompt in a specified format. If the provided link is not a direct repository link but instead links to issues or pull requests, a query context section containing the content of the issue or PR thread is also included.
<details>
<summary>Click to view responder prompt format</summary> 
Here is a list of files in the repository that may help you answer the query:<br>
{pairs of (file_name, file_content)}<br>
___<br><br>
[INSTRUCTION]<br><br>
You are an expert software engineer. Answer the following user query using provided context retrieved from the {repository_name} repository.<br><br>
[QUERT CONTEXT]<br><br>
{issue/PR content}<br><br>
[USER QUERY]<br><br>
{user query}<br><br>
</details>

## Further Analysis and Results

### Style Control

Style (length and Markdown formatting) significantly impacts model ranking. A better formatted or visually appealing answer, though not necessarily better, is more likely to win. The style-controlled leaderboard isolates writing style from content quality. For details on our methodology, refer to [this blog post](https://blog.lmarena.ai/blog/2024/style-control/).
<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">confidence interval</th>
      <th style="padding: 8px; border: 1px solid lightgray;">rating (rounded)</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;">GPT 4o (20241120)</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+33.89 | -22.00</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1036.9</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;">Claude 3.5 Sonnet (20241022)</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+24.27 | -23.53</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1022.92</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;">DeepSeek V3</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+26.37 | -21.74</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">1013.75</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;">Gemini 1.5 Pro</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+19.04 | -21.81</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">996.66</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;">Gemini 2.0 Flash Exp</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+18.59 | -15.34</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">991.48</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;">GPT 4o mini (20240718)</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+32.58 | -39.27</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">984.68</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;">LLaMA 3.1 405B Instruct FP8</td>
      <td style="padding: 8px; border: 1px solid lightgray;">+22.31 | -28.44</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray;">952.3</td>
    </tr>
  </tbody>
</table>
</div>
<p style="color:gray; text-align: center;">Table 4.  Style-controlled Elo ratings of the responder models. </p>

Claude’s score and ranking has improved significantly with style control. GPT-4O's score has decreased, greatly narrowing its lead over other models. 

**Why isn’t Claude’s score as high as its ranking on the coding leaderboard in ChatBot Arena?**

This discrepancy is likely because a significant portion of user queries are not focused on strictly code-writing tasks. Instead, many users ask for guidance on how to use the repository, its purpose, or other high-level explanations. These types of queries shift the focus away from pure coding abilities, impacting scores for models like Claude.

<details>
<summary> Click to expand an example of Claude vs. GPT-4o with identical retrievals</summary>
<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">Claude 3.5 Sonnet (20241022) Response</th>
      <th style="padding: 8px; border: 1px solid lightgray;">GPT 4o (20241120) Response</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;vertical-align: top;">Let me analyze the code from the provided context to explain the potential reasons for Blackbox provider's slower performance in version 0.4.0.0.<br><br>Looking at the Blackbox.py implementation, there are several key changes that could contribute to slower performance:<br><br>1. **Validation Process**: The provider now implements a more complex validation process that requires fetching and parsing JavaScript files to obtain a validation token:<br><br>```python<br>@classmethod<br>async def fetch_validated(cls):<br> cached_value = cls._load_cached_value()<br> <br> async with aiohttp.ClientSession() as session:<br> # Tries multiple URLs<br> urls_to_try = [<br> \"https:\/\/www.blackbox.ai\",<br> \"https:\/\/api.blackbox.ai\"<br> ]<br> <br> for base_url in urls_to_try:<br> try:<br> async with session.get(base_url) as response:<br> if response.status != 200:<br> continue<br> <br> page_content = await response.text()<br> js_files = re.findall(r'static\/chunks\/\\d{4}-[a-fA-F0-9]+\\.js', page_content)<br> # Additional JS file parsing...<br>```<br><br>2. **Multiple URL Attempts**: The code now tries multiple URLs and has to process multiple JavaScript files, which adds overhead:<br>- It first tries blackbox.ai<br>- Then falls back to api.blackbox.ai<br>- For each URL it has to download and parse multiple JS files<br><br>3. **Caching Implementation**: While there is a caching mechanism implemented:<br><br>```python<br>@classmethod<br>def _load_cached_value(cls) -> str | None:<br> cache_file = cls._get_cache_file()<br> if cache_file.exists():<br> try:<br> with open(cache_file, 'r') as f:<br> data = json.load(f)<br> return data.get('validated_value')<br>```<br><br>The cache might not be as effective as in previous versions, requiring more frequent validation token refreshes.<br><br>4. **Additional Model Support**: The provider now supports many more models and features:<br>```python<br>vision_models = [default_vision_model, 'gpt-4o', 'gemini-pro', 'gemini-1.5-flash', 'llama-3.1-8b', 'llama-3.1-70b', 'llama-3.1-405b']<br>web_search_models = ['blackboxai', 'meta-llama\/Llama-3.3-70B-Instruct-Turbo', 'meta-llama\/Meta-Llama-3.1-405B-Instruct-Lite-Pro']<br>```<br><br>This expanded model support likely requires additional validation and processing logic.<br><br>To improve performance, you could:<br><br>1. Optimize the validation process to reduce unnecessary requests<br>2. Implement more aggressive caching of the validation token<br>3. Only load model information for the specific model being used<br>4. Consider using connection pooling to reduce connection overhead<br><br>The tradeoff seems to be between security\/functionality and speed - the new version implements more robust validation and supports more features, but at the cost of performance.<br><br>Would you like me to elaborate on any of these points or provide specific suggestions for optimizing the provider's performance?
      </td>
      <td style="padding: 8px; border: 1px solid lightgray;vertical-align: top;">In version **0.4.0.0** of the `gpt4free` repository, the **Blackbox provider** is slower compared to version **0.3.9.7** likely due to several changes introduced in the newer implementation. Here's an analysis based on the provided context:<br><br>---<br><br>### 1. **Enhanced `fetch_validated` Method in `Blackbox`**<br> - In **version 0.4.0.0**, the `Blackbox` provider introduces a more complex and robust mechanism for fetching and validating the `validated_value`. This involves:<br> - **Fetching multiple JavaScript files** from the `https:\/\/www.blackbox.ai` or `https:\/\/api.blackbox.ai` endpoints.<br> - **Regex-based parsing of UUIDs** in JavaScript files to extract the `validated_value`.<br> - **Checking the context around the UUID** to ensure it is valid.<br> - **Retries and handling multiple URLs**, which adds overhead.<br> - This validation mechanism includes additional asynchronous calls and error handling. While it improves reliability, it significantly increases the response time.<br><br> **Comparison to version 0.3.9.7**:<br> - The earlier version likely used a simpler or cached approach for this process, avoiding the need to repeatedly process JavaScript files and perform context validation.<br><br>---<br><br>### 2. **Increased Error Handling and Retrying**<br> - The new implementation introduces more robust error-handling mechanisms, including:<br> - **Retry loops** for fetching JavaScript files and API calls.<br> - **Exponential backoff with random delays** when processing requests.<br> - **Fallbacks for cached values** if validation fails.<br> - While this improves reliability and stability, each retry and delay adds to the total processing time.<br><br>---<br><br>### 3. **Web Search Integration**<br> - The `create_async_generator` function now has an optional **web search** feature:<br> - If `web_search` is enabled, the provider calls an external search engine (via `get_search_message`) to refine the user\u2019s query.<br> - Although `web_search` is optional, if enabled, it introduces significant latency due to network calls and extra processing.<br><br>---<br><br>### 4. **Increased Complexity in Request Data Preparation**<br> - The new implementation constructs a more detailed payload for the API request:<br> - **Agent modes** (e.g., `agentMode`, `trendingAgentMode`) are retrieved and included in the payload.<br> - **Model-specific settings**, including image generation and other configurations, are passed in the data.<br> - **Image processing** (if images are included) involves converting to data URIs.<br> - This additional processing step before sending the request increases the latency.<br><br>---<br><br>### 5. **More Advanced Delay and Retry Mechanisms**<br> - When an API request fails, the system uses:<br> - **Exponential backoff delays**: `delay * (2 ** attempt) + random.uniform(0, 1)`<br> - **Retries (default `max_retries=3`)**: Every failed request results in subsequent retries.<br> - These features, while improving resilience, can slow down the overall response time if the API is unreliable or under heavy load.<br><br>---<br><br>### 6. **Additional Debugging and Logging**<br> - The new version includes enhanced debugging and logging mechanisms (`debug.log`):<br> - Each step, including validation, retries, and errors, is logged.<br> - While useful for debugging, this can also slightly slow down execution, especially in development or verbose logging environments.<br><br>---<br><br>### 7. **Potential API Changes on Blackbox's Side**<br> - If the Blackbox API itself has undergone changes between the two versions, such as stricter validation or slower endpoints, this could also contribute to the slowdown. The need to fetch and validate `validated_value` repeatedly suggests that the newer version is designed to handle a more restrictive or rate-limited API.<br><br>---<br><br>### 8. **Cache Mechanism vs. Real-Time Validation**<br> - In version **0.3.9.7**, the `validated_value` may have been cached and reused across requests, reducing overhead.<br> - In version **0.4.0.0**, the `_load_cached_value` and `_save_cached_value` methods are still present, but more emphasis is placed on real-time validation through `fetch_validated`, which is inherently slower.<br><br>---<br><br>### Summary of Reasons for Slowdown<br>1. **More Robust `fetch_validated` Method**:<br> - Repeatedly fetching and parsing JavaScript files for UUID validation adds significant overhead.<br><br>2. **Increased Error Handling and Retries**:<br> - New retry mechanisms and delays increase resilience but add latency.<br><br>3. **Optional Web Search**:<br> - If enabled, it introduces additional network calls and processing time.<br><br>4. **Enhanced Payload Preparation**:<br> - More detailed request data adds preprocessing time.<br><br>5. **Reliance on Real-Time Validation**:<br> - Real-time validation of the `validated_value` is slower than relying on cached values.<br><br>6. **API Changes on Blackbox's Side**:<br> - Stricter validation or rate-limiting by the Blackbox API could also be contributing.<br><br>---<br><br>### Recommendations to Improve Speed<br>To regain the speed of version **0.3.9.7**, consider:<br>1. **Caching the `validated_value`** more aggressively and reducing reliance on real-time validation.<br>2. **Optimizing the `fetch_validated` process** by limiting retries or checking for updated values less frequently.<br>3. **Disabling features like `web_search`** unless explicitly needed.<br>4. **Reducing retry attempts and exponential backoff delays** for faster error recovery in non-critical use cases.

  </td>
    </tr>
  </tbody>
</table>
</div>
</details>

## Retriever Control
Similar to style-control, the retriever-controlled leaderboard separates the effect of the retrievers from the content quality. 
<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">confidence interval</th>
      <th style="padding: 8px; border: 1px solid lightgray;">rating (rounded)</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">GPT 4o (2024-11-20)</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+11.68 | -11.98</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">1088.25</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">DeepSeek V3</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+21.65 | -21.98</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">1025.12</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">Gemini 2.0 Flash Exp</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+10.79 | -13.29</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">1005.13</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">Claude 3.5 Sonnet (20241022)</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+10.97 | -10.38</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">999.29</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">Gemini 1.5 Pro</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+14.67 | -15.06</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">970.41</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">LLaMA 3.1 405B Instruct FP8</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+16.62 | -17.61</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">911.50</td>
    </tr>
  </tbody>
</table>
</div>
<p style="color:gray; text-align: center;">Table 5. Retriever-controlled Elo ratings of the responder models. </p>
The retriever-controlled leaderboard shows only slight differences from the original, as the two chosen retrievers perform similarly and have little influence on the rankings

## Style + Retriever Control
<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">confidence interval</th>
      <th style="padding: 8px; border: 1px solid lightgray;">rating (rounded)</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">GPT 4o (2024-11-20)</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+31.30 | -22.97</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">1038.17</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">Claude 3.5 Sonnet (20241022)</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+23.35 | -20.84</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">1020.20</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">DeepSeek V3</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+24.76 | -22.04</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">1015.97</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">Gemini 1.5 Pro</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+19.79 | -19.26</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">990.42</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">Gemini 2.0 Flash Exp</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+17.05 | -15.65</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">986.87</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">LLaMA 3.1 405B Instruct FP8</td>
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">+18.71 | -26.04</td>
      <td style="padding: 8px; text-align: right; border: 1px solid lightgray; vertical-align: top;">947.07</td>
    </tr>
  </tbody>
</table>
</div>

<p style="color:gray; text-align: center;">Table 6. Style-and-retriever-controlled Elo ratings of the responder models. </p>

## Leaderboard Calculation
How do we get separate leaderboards for the retrievers and the responders from one set of battles? Extra features!

Chabot Arena leverages the [**Bradley-Terry**](https://en.wikipedia.org/wiki/Bradley%E2%80%93Terry_model) model for scoring model strength using pairwise battles. We adopt its [**statistical extension**](https://blog.lmarena.ai/blog/2024/extended-arena/) to evaluate the additional subparts–the retrievers–we integrate them as extra features just like the responder models. Each retriever feature takes values from {-1, 0, 1}, indicating whether it was active in the file retrieval for model_a, neither/both, or model_b, respectively. By performing Logistic Regression on these additional retriever features along with the original model features, we obtain coefficients that are later scaled to become the leaderboard scores. 
<img src="/assets/img/blog/repochat_arena/PIC_winrates.png" alt="Model Pairwise Winrates" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 8. Fraction of model A wins for all non-tied battles.</p>

## What's Next?
We are actively collecting more votes and integrating new models, with plans for more comprehensive analysis down the line. Additionally, we are exploring ways to enhance RepoChat by incorporating features such as support for private repositories, GitLab integration, and improvements to our retrieval process. Community contributions are welcome—feel free to ping us if you'd like to get involved!