#!/bin/bash
# =====================================================
# 一键使用 sf CLI 拉取 Salesforce Org Metadata（source format）并提交到 Git
# =====================================================

# 配置：修改为你的 Org alias 或用户名
ORG_ALIAS="resilientKoala"
GIT_REPO_URL="<your-git-repo-url>"

# STEP 1: 初始化 SFDX 项目（如果还没初始化）
if [ ! -f "sfdx-project.json" ]; then
    echo "Initializing SFDX project..."
    sf project create --name my-sfdx-app --output-dir .
fi

# STEP 2: 创建 manifest 目录和 package.xml（可拉取类型）
mkdir -p manifest
cat > manifest/package.xml <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types><members>*</members><name>ApexClass</name></types>
    <types><members>*</members><name>ApexTrigger</name></types>
    <types><members>*</members><name>ApexPage</name></types>
    <types><members>*</members><name>ApexComponent</name></types>
    <types><members>*</members><name>CustomObject</name></types>
    <types><members>*</members><name>CustomField</name></types>
    <types><members>*</members><name>Flow</name></types>
    <types><members>*</members><name>Profile</name></types>
    <types><members>*</members><name>PermissionSet</name></types>
    <types><members>*</members><name>Layout</name></types>
    <types><members>*</members><name>LightningComponentBundle</name></types>
    <types><members>*</members><name>StaticResource</name></types>
    <types><members>*</members><name>CustomTab</name></types>
    <types><members>*</members><name>CustomApplication</name></types>
    <types><members>*</members><name>RemoteSiteSetting</name></types>
    <types><members>*</members><name>NamedCredential</name></types>
    <types><members>*</members><name>EmailTemplate</name></types>
    <version>57.0</version>
</Package>
EOL

# STEP 3: 登录 Org（如果还没登录）
echo "Logging in to Org..."
sf login web --alias $ORG_ALIAS

# STEP 4: 拉取 Metadata 到 source format
echo "Retrieving Metadata from Org (source format)..."
sf project retrieve start \
    --manifest manifest/package.xml \
    --target-org $ORG_ALIAS \
    --source-dir force-app

# STEP 5: 提交到 Git
echo "Committing to Git..."
git add .
git commit -m "Initial commit: retrieve metadata from Org using sf CLI"
git branch -M main
git remote add origin $GIT_REPO_URL
git push -u origin main

echo "✅ All done! Metadata retrieved (source format) and pushed to Git using sf CLI."
