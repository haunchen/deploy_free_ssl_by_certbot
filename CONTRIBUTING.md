# Contributing to Free SSL Certificate Deployment

我們歡迎所有形式的貢獻！無論是回報 bug、建議新功能、改進文檔或提交程式碼。

## 如何貢獻

### 回報 Bug

如果您發現了 bug，請在 GitHub Issues 中建立一個新的 issue，並包含：

- **簡短且描述性的標題**
- **詳細的 bug 描述**
- **重現步驟**
- **預期行為**
- **實際行為**
- **系統環境**（作業系統、Nginx 版本等）
- **錯誤訊息或日誌**（如果有的話）

### 建議功能

我們歡迎新功能的建議！請在提出前：

1. 檢查是否已有類似的建議
2. 在 GitHub Issues 中建立一個 feature request
3. 清楚描述功能的用途和好處
4. 如果可能，提供實作的想法

### 提交程式碼

1. **Fork 專案**
   ```bash
   git clone https://github.com/haunchen/deploy_free_ssl_by_certbot.git
   cd deploy_free_ssl_by_certbot
   ```

2. **建立功能分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **進行修改**
   - 遵循現有的程式碼風格
   - 添加適當的註解
   - 確保腳本有適當的錯誤處理

4. **測試您的修改**
   - 在測試環境中執行腳本
   - 確保不會破壞現有功能
   - 測試錯誤情況的處理

5. **提交修改**
   ```bash
   git add .
   git commit -m "Add: 簡短描述您的修改"
   ```

6. **推送到您的 Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **建立 Pull Request**
   - 提供清楚的 PR 標題和描述
   - 說明修改的原因和內容
   - 如果修復了 issue，請參考該 issue 編號

## 程式碼規範

### Shell 腳本規範

- 使用 `#!/bin/bash` 作為 shebang
- 使用 `set -e` 來在錯誤時停止執行
- 變數名使用大寫字母和底線（如 `INPUT_DOMAIN`）
- 函數名使用小寫字母和底線
- 適當地使用引號包圍變數
- 添加有意義的註解

### 範例：

```bash
#!/bin/bash
set -e

# 檢查必要參數
if [ -z "$1" ]; then
    echo "Error: Missing required parameter"
    exit 1
fi

INPUT_DOMAIN="$1"

# 驗證域名格式
if [[ ! "$INPUT_DOMAIN" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Error: Invalid domain format"
    exit 1
fi
```

## 文檔

- 所有新功能都應該在 README.md 中記錄
- 重要的修改應該更新變更日誌
- 註解應該用繁體中文或英文撰寫
- 錯誤訊息應該清楚且有幫助

## 測試

在提交 PR 前，請確保：

- [ ] 腳本在 Ubuntu 18.04+ 上正常運作
- [ ] 腳本在 Debian 9+ 上正常運作
- [ ] 錯誤處理正常運作
- [ ] 所有新功能都有適當的文檔

## 行為準則

- 保持友善和尊重
- 歡迎新手貢獻者
- 專注於建設性的反饋
- 尊重不同的觀點和經驗

## 需要幫助？

如果您有任何問題：

- 查看現有的 Issues 和 Pull Requests
- 在 GitHub Issues 中提問
- 詳細描述您遇到的問題

感謝您的貢獻！🎉

---

# English Version - Contributing Guide

We welcome all forms of contributions! Whether it's reporting bugs, suggesting new features, improving documentation, or submitting code.

## How to Contribute

### Reporting Bugs

If you find a bug, please create a new issue on GitHub Issues and include:

- **Short and descriptive title**
- **Detailed bug description**
- **Steps to reproduce**
- **Expected behavior**
- **Actual behavior**
- **System environment** (OS, Nginx version, etc.)
- **Error messages or logs** (if any)

### Suggesting Features

We welcome suggestions for new features! Before submitting:

1. Check if similar suggestions already exist
2. Create a feature request in GitHub Issues
3. Clearly describe the purpose and benefits of the feature
4. If possible, provide implementation ideas

### Submitting Code

1. **Fork the project**
   ```bash
   git clone https://github.com/haunchen/deploy_free_ssl_by_certbot.git
   cd deploy_free_ssl_by_certbot
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Add appropriate comments
   - Ensure scripts have proper error handling

4. **Test your changes**
   - Run scripts in test environment
   - Ensure existing functionality isn't broken
   - Test error case handling

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: brief description of your changes"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create Pull Request**
   - Provide clear PR title and description
   - Explain the reason and content of changes
   - If fixing an issue, reference the issue number

## Code Standards

### Shell Script Standards

- Use `#!/bin/bash` as shebang
- Use `set -e` to stop execution on errors
- Variable names use uppercase letters and underscores (e.g., `INPUT_DOMAIN`)
- Function names use lowercase letters and underscores
- Properly quote variables
- Add meaningful comments

### Example:

```bash
#!/bin/bash
set -e

# Check required parameters
if [ -z "$1" ]; then
    echo "Error: Missing required parameter"
    exit 1
fi

INPUT_DOMAIN="$1"

# Validate domain format
if [[ ! "$INPUT_DOMAIN" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Error: Invalid domain format"
    exit 1
fi
```

## Documentation

- All new features should be documented in README.md
- Important changes should update the changelog
- Comments should be written in Traditional Chinese or English
- Error messages should be clear and helpful

## Testing

Before submitting a PR, please ensure:

- [ ] Scripts work properly on Ubuntu 18.04+
- [ ] Scripts work properly on Debian 9+
- [ ] Error handling works correctly
- [ ] All new features have appropriate documentation

## Code of Conduct

- Be friendly and respectful
- Welcome new contributors
- Focus on constructive feedback
- Respect different viewpoints and experiences

## Need Help?

If you have any questions:

- Check existing Issues and Pull Requests
- Ask questions in GitHub Issues
- Describe your problem in detail

Thank you for your contribution! 🎉
