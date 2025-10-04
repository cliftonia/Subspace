# Renaming Project to Subspace

## Option 1: Use Xcode (RECOMMENDED)

This is the safest method as Xcode will update all references automatically.

### Steps:
1. **Open the project in Xcode**
2. **Select the project** in the navigator (top-level blue icon)
3. **In the right panel**, click on the project name to make it editable
4. **Type "Subspace"** and press Enter
5. **Xcode will ask** "Rename project content items?"
   - ✅ Check "Rename project content items"
   - Click "Rename"
6. **Xcode will update**:
   - Project name
   - Scheme names
   - Target names
   - Folder references
   - Bundle identifiers (from `com.cliftonbaggerman.Subspace` → `com.cliftonbaggerman.Subspace`)

### After Xcode Rename:
7. **Rename the repository folder**:
   ```bash
   cd /Users/cliftonbaggerman/Repos
   mv Subspace Subspace
   ```

8. **Update import statements** in test files:
   ```bash
   cd /Users/cliftonbaggerman/Repos/Subspace
   find . -name "*.swift" -type f -exec sed -i '' 's/@testable import Subspace/@testable import Subspace/g' {} +
   ```

9. **Verify build**:
   ```bash
   cd /Users/cliftonbaggerman/Repos/Subspace
   xcodebuild -scheme Subspace -destination 'platform=iOS Simulator,name=iPhone 17' build
   ```

---

## Option 2: Manual Rename Script (If Xcode method doesn't work)

**WARNING**: This is more complex and error-prone. Use Option 1 if possible.

### Step 1: Rename folder
```bash
cd /Users/cliftonbaggerman/Repos
mv Subspace Subspace
cd Subspace
```

### Step 2: Update all file contents
```bash
# Update Swift files
find . -name "*.swift" -type f -exec sed -i '' 's/sqaure.enix/Subspace/g' {} +
find . -name "*.swift" -type f -exec sed -i '' 's/Subspace/Subspace/g' {} +
find . -name "*.swift" -type f -exec sed -i '' 's/Subspace/Subspace/g' {} +

# Update Markdown files
find . -name "*.md" -type f -exec sed -i '' 's/sqaure.enix/Subspace/g' {} +
find . -name "*.md" -type f -exec sed -i '' 's/Subspace/Subspace/g' {} +
find . -name "*.md" -type f -exec sed -i '' 's/Subspace/Subspace/g' {} +

# Update project files
find . -name "*.pbxproj" -type f -exec sed -i '' 's/sqaure.enix/Subspace/g' {} +
find . -name "*.pbxproj" -type f -exec sed -i '' 's/Subspace/Subspace/g' {} +
find . -name "*.pbxproj" -type f -exec sed -i '' 's/Subspace/Subspace/g' {} +
```

### Step 3: Rename directories
```bash
mv Subspace Subspace
mv SubspaceTests SubspaceTests
mv SubspaceUITests SubspaceUITests
```

### Step 4: Update bundle identifier
Edit the project file or use Xcode to change:
- From: `com.cliftonbaggerman.Subspace`
- To: `com.cliftonbaggerman.Subspace`

---

## Recommended Bundle Identifier

**New Bundle ID**: `com.cliftonbaggerman.Subspace`

This follows Apple's reverse-DNS naming convention and is clean and professional.

---

## Files That Will Be Updated

### Swift Files (~90 references):
- All `//  Subspace` header comments → `//  Subspace`
- `@testable import Subspace` → `@testable import Subspace`
- Any string literals referencing the app name

### Documentation:
- `CLEANUP_PLAN.md`
- `REFACTOR_SUMMARY.md`
- `CLEAN_ARCHITECTURE.md`
- `CLEANUP_SUMMARY.md`
- `README.md`
- `CODE_AUDIT.md`
- `BACKEND_SETUP.md`

### Xcode Project Files:
- `Subspace.xcodeproj` → `Subspace.xcodeproj`
- Scheme names
- Target names
- Build settings

---

## Verification Checklist

After renaming, verify:

- [ ] Project builds successfully
- [ ] Tests run successfully
- [ ] App launches in simulator
- [ ] Bundle identifier is correct
- [ ] All imports work
- [ ] No "Subspace" references remain (except in git history)

Run this to check:
```bash
grep -r "sqaure" . --exclude-dir=".git" --exclude-dir="DerivedData"
```

Should return 0 results.

---

## My Recommendation

**Use Option 1 (Xcode rename)** - It's the safest and most reliable method. Xcode will handle all the complex project file updates automatically.

Let me know if you'd like me to help with any specific part of the rename process!
