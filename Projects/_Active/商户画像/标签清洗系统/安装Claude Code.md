一、如何安装Claude Code
基础教程：
http://cc.openllm.chat
https://oi2wmbx8v3f.feishu.cn/wiki/SyCGw3hj9iICDIkgXticQAE9nVh
在开始之前，请确保你的系统满足以下要求：
- 操作系统：Windows、macOS 或 Linux
- Node.js 版本 ≥ 18.0
- 稳定的网络连接
1. 安装Node.js
如果你已经安装了 Node.js 18+ 版本，可以跳过此步骤。
Ubuntu / Debian 用户
# 添加 NodeSource 存储库
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -

# 安装 Node.js
sudo apt-get install -y nodejs

# 验证安装
node --version
npm --version
Mac OS 用户
# 安装 Xcode 命令行工具
sudo xcode-select --install

# 安装 Homebrew（如未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 使用 Homebrew 安装 Node.js
brew install node

# 验证安装
node --version
npm --version
Windows用户
直接去官网下载对应的稳定的版本即可，或者使用nvm工具。
2. 卸载之前的镜像code(没有下载过可以跳过)
如果您先前安装过镜像Claude Code，请您务必先通过以下命令卸载（如果没有请跳过此步骤）
一定要卸干净，否则环境会出现问题。
npm uninstall -g @anthropic-ai/claude-code
卸载后再次输入 claude 命令，如果还是没有卸载成功，那就在终端输入
sudo -i
npm uninstall -g @anthropic-ai/claude-code
3. 安装 Claude Code
使用 npm 全局安装 Claude Code：
npm install -g @anthropic-ai/claude-code

# 验证安装
claude --version
如果遇到权限问题，可以尝试：
# macOS/Linux 用户
npm install -g @anthropic-ai/claude-code

# Windows 用户（以管理员身份运行）
npm install -g @anthropic-ai/claude-code
注意
如果安装过程中遇到网络问题，可以尝试使用国内 npm 镜像：
npm install -g @anthropic-ai/claude-code --registry https://registry.npmmirror.com
Windos配置环境变量
按 Win + R，输入 sysdm.cpl  按回车，点击"高级"选项卡，然后点击"环境变量"
添加系统变量 ：
在"系统变量"区域点击"新建"，添加第一个变量
变量名：ANTHROPIC_AUTH_TOKEN
变量值：cr-xxxx ，点击"确定"
添加第二个变量 ：再次点击"新建"
变量名：ANTHROPIC_BASE_URL
变量值：http://cc.openllm.chat/api
点击"确定"
重新打开cmd 运行claude code
macOS 配置环境变量
对于 zsh (默认)
echo 'export ANTHROPIC_BASE_URL="http://cc.openllm.chat/api"' >> ~/.zshrc
echo 'export ANTHROPIC_AUTH_TOKEN="您的API密钥"' >> ~/.zshrc
source ~/.zshrc
对于 bash (老版本)
echo 'export ANTHROPIC_BASE_URL="http://cc.openllm.chat/api"' >> ~/.bashrc
echo 'export ANTHROPIC_AUTH_TOKEN="您的API密钥"' >> ~/.bashrc
source ~/.bashrc
4. 验证环境变量设置
设置环境变量后，可以通过以下命令验证是否设置成功：
echo $ANTHROPIC_BASE_URL
echo $ANTHROPIC_AUTH_TOKEN
5. 预期结果示例:
http://cc.openllm.chat/api
cr_xxxxxxxxxxxxxx
6. 提前安装好MCP，保证后续使用的快速稳定：（非常关键！！！）
根据不同系统下载不同的安装包。
cleanup_claude_windows.bat
cleanup_claude_mac.sh
cleanup_claude_linux.sh
附件：安装教程（视频版本）
如果您不理解文字，请跟着视频一步步操作。
This content is only supported in a Feishu Docs
This content is only supported in a Feishu Docs
二、常见报错以及细节
7. 新版本token不显示
最近更新版本之后，询问问题的时候，并没有显示token了，大家会误以为是不是卡主了等疑惑。下面有两种方式可以解决。
方式一：使用 /config 命令进行配置，把Verbose output 修改成ture 即可。
[Image]
方式二：以后启动claude code的时候，使用 claude --verbose 命令进行启动
claude --verbose
8. 上下文过长或者文件过大
[Image]
这个问题是因为，你上下文太长了，太久没有clear，或者是你让claude code分析的文件太长了，token过大导致的。
9. 模型切换问题
[Image]
更新到 1.0.100 版本号之后，发现官方应该是换了模型，现在默认模型就是4.1opus和sonnet混用。
[Image]
所以使用后会报错，如上图。
大家首次进入Claude Code之后可以进行切换。
在Claude Code 中 使用 /model 命令进行切换，选择 Sonnet即可。
[Image]
10. 官方Apikey覆盖问题
这里有一个小伙伴遇到的一个新的报错，apikey配置的也是正确的，但是依然会报错，API Error （401 Invalid API key format）•Retrying in 5 seconds. （attempt 4/10）API Error （401 Invalid API key format）•Retrying in 5 seconds. （attempt 4/10）。
[Image]
Claude Code账号，官方的优先级非常高，所以配置了我们的api key会不生效。
解决方案： 
方式一： /logout 退出登录下就好了。
方式二：还有一个办法就是 看看这个地方的AUTH Token是不是这个环境变量。
[Image]
11. git安装包报错，无法下载Claude code
[Image]
git安装包：未命名文档。不需要魔法。
12. 本地禁止脚本安装，无法下载nodejs
[Image]
解决办法：
第一步：先输入指令：Get-ExecutionPolicy
第二步：再输入指令：Set-ExecutionPolicy RemoteSigned -Scope CurrentUser #推荐:允许本地脚本运行，远程脚本需签名（小tips：在#之前留个空格，保证其后文字为绿色）
13. 环境变量中配置了代理节点导致api连接错误
[Image]
解决方案：
针对于 系统：
解决方案（临时）：
Bash
```
set http_proxy=
set https_proxy=
```

Powershell
```
Remove-Item Env:http_proxy
Remove-Item Env:https_proxy
```

永久解决：
 - 重置 Windows HTTP 服务代理
Bash
```netsh winhttp reset proxy```
在环境变量中找到,并删除
http_proxy
https_proxy
针对于claude配置文件：
 用户级别的设置文件通常位于 `C:\Users\您的用户名\.claude\settings.json`。
 项目级别的设置文件可能在您当前工作目录下的 `.claude\settings.json` 文件中

**编辑配置文件**：
    *   用文本编辑器打开这个 `settings.json` 文件。
    *   检查其中是否有一个 `env` 的部分，并且里面设置了代理，例如：
        ```json
        {
          "env": {
            "http_proxy": "http://127.0.0.1:17262",
            "https_proxy": "http://127.0.0.1:17262"
          }
        }
        ```
    *   如果存在，请将相关的代理设置行删除。
做完上述指令，再次输入/status命令检查，当看到出现以下示例即可正常使用
[Image]
三、Claude Code 有哪些功能？
1. Claude Code 直接进行交互：
- 您可了解 Claude Code 常见的工作流，但Claude Code 比您想象的更强大。
- Claude Code 提供两种主要的交互方式：
  - 交互模式：运行 claude 启动 REPL 会话
  - 单次模式：使用 claude -p "查询" 进行快速命令
  - 您可以参考：
# 启动交互模式
claude

# 以初始查询启动
claude "解释这个项目"

# 运行单个命令并退出
claude -p "这个函数做什么？"

# 处理管道内容
cat logs.txt | claude -p "分析这些错误"
  - 对于 Claude Code Client的常用参数和功能，您可以访问官方文档：CLI 使用和控制 - Anthropic
  
2. Claude Code 支持压缩上下文以节省点数：
  - Claude Code 通常会有长上下文，我们建议您使用以下斜杠命令来压缩以节省点数，较长的上下文往往需要更多点数。
/compact [您的描述]
3. Claude Code 能够恢复以前的对话：
  - 使用以下命令可以恢复您上次的对话
claude --continue
    - 这会立即恢复您最近的对话，无需任何提示。
    - 您如果需要显示时间，可以输入此命令
claude --resume
      - 这会显示一个交互式对话选择器，显示：
        - 对话开始时间
        - 初始提示或对话摘要
        - 消息数量
      - 使用箭头键导航并按Enter选择对话，您可以使用这个方法选择上下文。
4. Claude Code 可以处理图像信息：
      - 您可以使用以下任何方法：
        1. 将图像拖放到Claude Code窗口中（在MacOS上）
        2. 复制图像并使用Ctrl+v粘贴到CLI中（在MacOS上）
        3. 提供图像路径
> 分析这个图像：/path/to/your/image.png
      - 您可以完全使用自然语言要求他进行工作，如：
> 这是错误的截图。是什么导致了它？ 
> 这个图像显示了什么？ 
> 描述这个截图中的UI元素 
> 生成CSS以匹配这个设计模型 
> 什么HTML结构可以重新创建这个组件？ 
5. Claude Code 支持深入思考：
        - 您需要通过自然语言要求其进行深入思考
> 我需要使用OAuth2为我们的API实现一个新的身份验证系统。深入思考在我们的代码库中实现这一点的最佳方法。
> 思考这种方法中潜在的安全漏洞 
> 更深入地思考我们应该处理的边缘情况
          - 推荐您在使用复杂问题的时候使用这一功能，这也会消耗大量的额度点数。
          另外，有一个更有效的思维模式，可以使其解决难题的能力提高 10 倍，解锁克劳德真实大脑。而且只需进行一次设置即可。在.claude/settings.local.json 中启用 MAX THINKING TOKENS
{
  "env":{
    "MAX THINKING TOKENS"="32000"
    }
 }
6. Claude Code 支持管理命令历史：
          - 历史按工作目录存储
          - 使用 /clear 命令清除
          - 使用上/下箭头导航（参见上面的键盘快捷键）
          - Ctrl+R：反向搜索历史（如果终端支持）
          - 注意：历史扩展（!）默认禁用
7. Claude Code 通过 Claude.md 存储重要记忆：
          - 您可以使用以下命令设置一个CLAUDE.md文件来存储重要的项目信息、约定和常用命令。
> /init
            - 包括常用命令（构建、测试、lint）以避免重复搜索
            - 记录代码风格偏好和命名约定
            - 添加特定于您项目的重要架构模式
            - CLAUDE.md记忆可用于与团队共享的指令和您的个人偏好。
            - 更多关于记忆的设置，您可以访问此官方文档了解：Claude Code 概述 - Anthropic
            - 在官方文档中，此部分记录了记忆的常用用法：管理Claude的记忆 - Anthropic
8. Claude Code 支持上下文通用协议（MCP）：
          - 模型上下文协议(MCP)是一个开放协议，使LLM能够访问外部工具和数据源。
          - 这是高级功能，您可以访问此文档获取更多配置信息：Introduction - Model Context Protocol
          - Claude Code不仅支持接入MCP，同样支持作为MCP服务器等各类高级功能，您可以访问此文档获得更多信息：教程 - Anthropic
          更多详细教程：
https://mp.weixin.qq.com/s/TsarV8I_t8b7wUYHUjusow
https://mp.weixin.qq.com/s/gHDAM7Mv_dsuIllWmGU0tQ
https://mp.weixin.qq.com/s/dgVOFDkpIqg90Bie_FCyiw
https://mp.weixin.qq.com/s/2-vu89T2aVDK41N02PjzWA
四、Claude Code 常见命令和快捷键
9. Claude Code 常见的/ 命令：
This content is only supported in a Feishu Docs
10. Claude Code 常见的 CLI 命令：
              https://docs.anthropic.com/zh-CN/docs/claude-code/cli-reference
This content is only supported in a Feishu Docs
11. Claude Code 常见的 CLI 参数：
This content is only supported in a Feishu Docs
12. Claude Code 常用的快捷键：
13. 通用控制：
This content is only supported in a Feishu Docs
14. 多行输入：
This content is only supported in a Feishu Docs
15. 快速命令：
This content is only supported in a Feishu Docs
五、Claude code如何装进不同的IDE
[Image]
命令行：/ide，选择本地已经安装好的ide
16. VS code/Trae
http://docs.anthropic.com/zh-CN/docs/claude-code/ide-integrations
17. Roo code
https://docs.roocode.com/update-notes/v3.21.4
18. kilocode
https://kilocode.ai/docs/zh-CN/providers/anthropic
19. 酒馆
20. 如何接入N8N
[Image]
