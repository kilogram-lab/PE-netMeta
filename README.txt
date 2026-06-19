肺栓塞网状 Meta 分析项目文件夹说明

本项目主题：
成人急性中危肺栓塞（intermediate-risk PE）治疗策略的 RCT-only 六节点网状 Meta 分析。

当前核心 PICOS 版本：
PICOS v0.2

当前候选 NMA 节点：
AC    单纯抗凝
ST    系统溶栓
CDT   导管导向溶栓
USCDT 超声辅助导管导向溶栓
LBAT  大口径抽吸取栓
CAT   导管辅助抽吸取栓

文件夹用途：

00_protocol
用于保存研究方案、PROSPERO 注册草稿、PICOS 版本、纳入排除标准、结局定义、节点定义、统计分析计划、偏倚风险评价计划、GRADE/CINeMA 计划等 protocol 相关文件。

01_search_strategy
用于保存各数据库检索策略、检索式、检索日期、数据库导出记录、去重记录、检索日志、补充检索记录、ClinicalTrials.gov/WHO ICTRP 等注册库检索结果。

02_papers_pdf
用于保存纳入研究、待筛选全文、关键背景文献和指南 PDF。建议后续按 included、excluded_fulltext、background、guidelines 等子文件夹整理。

03_screening
用于保存题录筛选表、标题摘要筛选记录、全文筛选记录、排除理由表、PRISMA flow diagram 数据、EndNote/Zotero/Rayyan/Covidence 导出文件等。

04_data_extraction
用于保存 RCT 数据提取表、研究基本信息、PICOS 判定、风险分层、治疗节点映射、结局数据、RoB 2.0 评价表、数据核对记录和最终可分析数据集。

05_analysis_R
用于保存 R 代码、统计分析脚本、netmeta/gemtc/BUGS/JAGS/Stan 相关文件、分析输入数据、模型输出、敏感性分析、亚组分析、异质性和不一致性分析、CINeMA/GRADE 输入文件等。

06_figures
用于保存网络图、森林图、league table、SUCRA/P-score 排序图、漏斗图、风险偏倚图、PRISMA 图、疗效-安全性二维图、CINeMA/GRADE 证据图，以及投稿用高分辨率图片。

07_manuscript
用于保存论文正文草稿、摘要、cover letter、投稿信、回应审稿人文件、补充材料、表格、参考文献文件、期刊格式化版本和最终投稿版本。

99_archive
用于保存过期版本、废弃分析、旧检索结果、旧表格、旧图、历史草稿和临时归档材料。重要文件移入前应确认新版已经存在，避免误删可追溯记录。

项目记录规则：
每次进行检索、筛选、数据提取、统计分析、绘图、制表、证据质量评价、论文写作或文件整理后，都要更新默认输出文件夹中的“方法和结果.txt”。写入前后均需全文读取核对，避免前后矛盾。

GitHub 规则：
代码、脚本、README、protocol 辅助文件和轻量项目说明可提交到 GitHub 仓库。
大型 PDF、原始全文、临时文件、输出结果、论文材料和敏感数据默认不上传 GitHub，仍放在本地默认输出文件夹或相应资料文件夹中。
