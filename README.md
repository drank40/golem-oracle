On-chain code to implement an LLM oracle prompted with https://github.com/guidance-ai/guidance

This is used to bring LLM (Llama, GPT-4, Bing ...) prompts on Ethereum, by specifying a consistent and public format
with which the prompts will be answered using Guidance, making it possible to plug these prompts into a Smart Contract
in an automated and trustless manner.

**NOTE** : the backend code managing prompt conditioning and event filtering is not public yet, contact me if you're interested

To build this project you will need the **Foundry** framework, refer to https://book.getfoundry.sh/

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```
