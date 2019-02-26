mine无法实时更新，更新方法
1. 执行两遍state.highstate（脚本没有追加模板功能，待更新）
2. 手动mine.update

执行步骤：
1. salt \* state.highstate
2. salt \* mine.update
3. salt -N monitors state.sls roles.add_monitor
