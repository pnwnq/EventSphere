# Cursor 效率指南

## 1. AI 助手使用方法
1. 使用清晰、具体的指令
2. 提供上下文信息
3. 分步骤提问复杂问题
4. 利用 AI 进行代码审查和优化
5. 在项目初始化时，@ CursorEfficiencyGuidelines 并指示"AI初始化"
6. 在继续项目时，@ CursorEfficiencyGuidelines 并说"我又来了"，AI 将继续下一步

## 2. 项目管理策略
1. 定期更新项目文档
2. 使用版本控制系统（如 Git）
3. 遵循代码规范
4. 进行定期代码审查
5. 保持与团队的沟通
6. 使用 UpdateInstructions.md 作为文档更新的指南

## 3. Cursor 快捷键和功能
- Cmd/Ctrl + P：快速打开文件
- Cmd/Ctrl + Shift + F：全局搜索
- Cmd/Ctrl + /：注释/取消注释
- Cmd/Ctrl + D：选择下一个相同的文本
- Cmd/Ctrl + Shift + L：选择所有相同的文本
- 使用 Composer 功能推进主要开发流程
- 利用 Chat 功能理解需求和梳理思路

## 4. 最佳实践
1. 项目初始化：
   - 查看现有的所有文档以启动初始化流程
   - 按照 AI 助手的指导完成初始化步骤
   - 确保所有核心文档都已创建并初步填充
2. 日常开发：
   - 经常参考项目文件夹中的规范文档
   - 遵循 System prompt 保持在正确的开发轨道上
   - 定期更新 ProjectRequirements.md 和 FunctionalDesign.md
   - 及时记录代码变更到 CodeChangeLog.md
3. 代码质量管理：
   - 使用 AI 进行代码审查和优化
   - 遵循项目的编码规范
   - 编写单元测试和集成测试
4. 文档管理：
   - 使用 UpdateInstructions.md 作为更新其他文档的指南
   - 保持 README.md 的及时更新，反映项目的最新状态
5. 效率提升：
   - 熟练使用 Cursor 的快捷键和功能
   - 利用 AI 助手解决复杂问题和优化代码

## 5. 项目初始化流程
1. @ CursorEfficiencyGuidelines 并指示"AI初始化"
2. AI 助手将引导您完成以下步骤：
   a. 提供项目名称（必须使用英文）和简要描述
   b. 初始化 Git 仓库并要求用户提供远程仓库地址
   c. 初始化并完善所有核心文档（README.md, ProjectRequirements.md, FunctionalDesign.md, CodeChangeLog.md）
   d. 设置开发环境并创建初始代码结构
3. 审查 AI 助手初始化的核心文档
4. 重点关注 ProjectRequirements.md 的完善
5. 根据项目需求，开始 FunctionalDesign.md 的初步设计
6. 记录初始化过程到 CodeChangeLog.md

## 6. AI 初始化指令
当收到"AI初始化"指令时，AI 助手将：
1. 询问用户项目名称（强调必须使用英文）和简要描述
2. 指导用户初始化 Git 仓库：
   a. 运行 `git init` 命令
   b. 创建 .gitignore 文件
   c. 要求用户提供远程仓库地址（如 GitHub 仓库 URL），并强调仓库名称必须使用英文
   d. 指导用户运行以下命令连接远程仓库：
      ```
      git remote add origin <远程仓库地址>
      git branch -M main
      git push -u origin main
      ```
3. 更新 README.md 文档，填入项目名称和描述
4. 初始化 ProjectRequirements.md，提示用户填写核心需求
5. 创建基本的 FunctionalDesign.md 结构
6. 在 CodeChangeLog.md 中记录项目初始化
7. 指导用户完成下一步操作

## 7. 持续改进
1. 定期回顾本指南，确保其与项目需求和团队实践保持一致
2. 鼓励团队成员分享使用 Cursor 和 AI 助手的经验和技巧
3. 根据项目进展和团队反馈，更新和优化工作流程
4. 探索 Cursor 的新功能，并将有价值的发现整合到工作流程中

## 8. 项目继续指令
当收到"我回来了"指令时，AI 助手将：
1. 回顾上次会话的进度和状态
2. 提醒用户当前的任务或下一步操作
3. 如果正在进行设备测试，询问测试进展并更新 TestingNotes.md
4. 根据项目当前阶段，提供相应的建议或指导
5. 更新相关文档，如 CodeChangeLog.md，以反映最新进展

注意：当您 @ CursorEfficiencyGuidelines 并说"我回来了"时，AI 助手将自动继续项目的下一步骤。
