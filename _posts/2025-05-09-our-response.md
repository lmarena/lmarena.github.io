---
layout: distill
title: "Our Response to 'The Leaderboard Illusion' Writeup"
description:
giscus_comments: true
date: 2025-05-09
featured: true
thumbnail: assets/img/blog/our_response/cover.png
authors:
  - name: LMArena Team
    affiliations:
      name: LMArena
---

Recently, a writeup titled "The Leaderboard Illusion" has been circulating with several claims and recommendations about the Chatbot Arena leaderboard. We are grateful for the feedback and have plans to improve Chatbot Arena as a result of our ongoing discussions with the authors.

**Arena's mission is to provide truthful and scientific evaluation of models across diverse domains, grounded in real-world uses.** This guiding principle shapes how we design our systems and policies to support the AI research and development community. Clear communication and shared understanding help move the field forward, and we’re committed to being active, thoughtful contributors to that effort. As such, we always welcome the opportunity to bring more transparency into how the platform works and what could be improved. There are thoughtful points and recommendations raised in the writeup that are quite constructive, and we’re actively considering them as part of our ongoing work.


To begin, we are excited to address some of the recommendations raised in the writeup head on. Here is an outline of our preliminary plans:
- <p style="font-weight: 400;">Since March 2024, <a href="https://blog.lmarena.ai/blog/2024/policy/">our policy</a> has established rules for pre-release testing. In a future policy release, we will explicitly state that model providers are all allowed to test multiple variants of their models pre-release, subject to our system's constraints.</p>
- <p style="font-weight: 400;">We will increase clarity about how models are retired from battle mode and explicitly mark which models are retired.</p>
- <p style="font-weight: 400;">Previously, we announced pre-release-tested models on the leaderboard after 2,000 votes had been accumulated since the beginning of testing. While the selection bias vanishes rapidly due to continuous testing with fresh user feedback, we will mark model scores as "provisional" until additional 2,000 fresh votes have been collected after model release, if more than 10 models were pre-release tested in parallel.</p>

While we welcome feedback and open discussion, the piece also contains several incorrect claims. We believe it’s important to address these points of factual disagreement directly. Our goal is not to criticize, but to help strengthen the reliability of AI evaluations. Rather than seeing these critiques as conflict, we see it as an opportunity for collaboration: a chance to clarify our approach, share data and learn together to help paint a fuller picture for analysis.


Below is a breakdown of the factual concerns we identified that affect the claims in the paper. We have been in active and productive conversation with the authors about these concerns, have shared these directly with them, and are working together to amend the claims in the paper:
<img src="/assets/img/blog/our_response/response-1.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 95%">


- <p style="font-weight: 400;">Claim: Open source models represent 8.8% on the leaderboard, implying proprietary models benefit most.</p>
- <p style="font-weight: 400;">Truth: Official <a href="https://topic.lmarena.ai/blog/2025/our-response/">Chatbot Arena stats</a> (published 2025/4/27) show <b>Open Models at 40.9%</b>. The writeup’s calculation is missing open-weight models (e.g., Llama, Gemma), significantly undercounting the open models.</p>


<img src="/assets/img/blog/our_response/response-2.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 95%">


- <p style="font-weight: 400;">Claim: Pre-release testing can boost Arena Score by 100+ points.</p>
- <p style="font-weight: 400;">Truth: The numbers in the original plot are <b>unrelated to Chatbot Arena</b>. The plot is a simulation - using <b>Gaussians</b> with mean 1200 and an arbitrarily chosen variance to illustrate their argument. It plots the maximum as the number of Gaussians grows. The larger the number of Gaussians, the larger is their maximum, and the numerical value is driven by the variance (arbitrarily chosen by authors), not by anything in Chatbot Arena's policies or actual performance.
- <p style="font-weight: 400;">Truth: <b>Boosts in a model’s score due to pre-release testing are minimal.</b> Because Arena is constantly collecting <b><a href="https://blog.lmarena.ai/blog/2025/freshness/">fresh data</a> from new users</b>, selection bias quickly goes to zero. Our analysis shows the effect of pre-release testing is smaller than claimed with finite data (around +11 Elo after 50 tests and 3000 votes) and diminishes to zero as fresh evaluation data accumulates. The "claimed effect" is a significant overstatement of the "true effect” under the Bradley-Terry model. See further technical analysis <a href="https://docs.google.com/document/d/1j5kEbl5TkRSbtVMdh5uRJSfLHiNjxtmCdGxKh2hnl1Q/edit?tab=t.0">here</a>.
- <p style="font-weight: 400;">Truth: Any non-trivial boost in Arena score has to come from substantial model improvements. Chatbot Arena helps providers identify their best models, and that is a good thing. A good benchmark should help people find the best model. Both model providers and the community benefit from getting this early feedback.</p>

<img src="/assets/img/blog/our_response/response-3.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 95%">


- <p style="font-weight: 400;">Claim: Submitting the same model checkpoint can lead to substantially different scores.</p>
- <p style="font-weight: 400;">Truth: Submitting the same model checkpoint leads to scores within a reasonable confidence interval. In their reporting of their Chatbot Arena results, <b>the confidence intervals are omitted</b>, although we shared them with the authors. <u>There's no evidence that rankings would differ</u>. For the example cited, scores like 1069 (±27) and 1054 (±18/22) have overlapping confidence intervals, meaning the variations are within the expected statistical noise, not indicative of substantially different underlying performance.</p>

<img src="/assets/img/blog/our_response/response-4.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 95%">


- <p style="font-weight: 400;">Claim: Big labs are given preferential treatment in pre-release testing.</p>
- <p style="font-weight: 400;">Truth: Models are treated fairly according to our model testing policy -- any model provider can submit as many public and private variants as they would like, as long as we have capacity for it. <b>Larger labs naturally submit more models because they develop more models, but all have access.</b> Also, accounting for vision models as well, we helped Cohere evaluate 9 pre-release models (from 2025/1-present), which is 2-3x more pre-release tests than labs like xAI/OpenAI.</p>

<img src="/assets/img/blog/our_response/response-5.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 95%">


- <p style="font-weight: 400;">Claim: Chatbot Arena has an "unstated policy" allowing preferential pre-release testing for select providers.</p>
- <p style="font-weight: 400;">Truth: Chatbot Arena's policy regarding the evaluation of unreleased models has been <b>publicly available for over a year</b>, published on March 1, 2024. There's no secret or unstated policy. It has always been our policy to only publish the results for publicly available models.</p>


<img src="/assets/img/blog/our_response/response-6.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 95%">


- <p style="font-weight: 400;">Claim: A 112% performance gain can be achieved in Chatbot Arena by incorporating Chatbot Arena data.</p>
- <p style="font-weight: 400;">Truth: The experiment cited for this gain was conducted on <b>"Arena-Hard," a static benchmark with 500 data points that uses an LLM judge, and no human labels.</b> This is not representative of Chatbot Arena. This claim with respect to Chatbot Arena is not supported by evidence.</p>


Finally, we make one more clarification, which is not meant to be a factual disagreement – just a clarification for those that haven’t read our policy to see how models are sampled. 

<img src="/assets/img/blog/our_response/response-7.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 95%">


- <p style="font-weight: 400;">Clarification: <b>The best models, regardless of provider, are upsampled to improve the user experience.</b> The <a href="https://blog.lmarena.ai/blog/2024/policy/">Arena policy</a> above states how we sample models in battle mode in detail. It so happens that the biggest labs often have multiple of the best models, but as the plot from the writeup shows, we also maintain strong diversity and sample models from other providers as well. See the historical fraction of battles on a per-provider basis on our <a href="https://blog.lmarena.ai/blog/2025/two-year-celebration/">blog</a>.</p>

We stand by the integrity and transparency of the Chatbot Arena platform. We welcome constructive feedback, especially when it helps us all build better tools for the community. However, it's crucial that such critiques are based on accurate data and a correct understanding of our publicly stated policies and methodologies. 

**Arena's mission is to provide truthful and scientific evaluation of models across diverse domains, grounded in real-world uses.** This commitment drives our continuous efforts to refine Arena's evaluation mechanisms, ensure methodological transparency, and foster trust across the AI ecosystem. We stand by the integrity and transparency of the Chatbot Arena platform. We welcome constructive feedback, especially when it helps us all build better tools for the community. However, it's crucial that such critiques are based on accurate data and a correct understanding of our publicly stated policies and methodologies.

We encourage everyone to review our <a href="https://blog.lmarena.ai/blog/2024/policy/">policy</a>, <a href="https://arxiv.org/abs/2403.04132">research paper</a> and <a href="https://huggingface.co/lmarena-ai">open datasets</a>. Our goal remains to provide a valuable, community-driven resource for LLM evaluation.
