const fs = require('fs');
const path = require('path');

const outDir = path.resolve(__dirname, '../public');
const manifestPath = path.join(outDir, 'manifest.json');

const removeCompiledAssets = (subDir) => {
  const dirPath = path.join(outDir, 'assets', subDir);

  if (!fs.existsSync(dirPath)) {
    return;
  }

  const entries = fs.readdirSync(dirPath);

  entries.forEach((entry) => {
    const entryPath = path.join(dirPath, entry);
    if (fs.lstatSync(entryPath).isFile()) {
      fs.unlinkSync(entryPath);
    }
  });
};

removeCompiledAssets('css');
removeCompiledAssets('js');

if (fs.existsSync(manifestPath)) {
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf-8'));
  Object.values(manifest).forEach(({ file }) => {
    if (file && (file.endsWith('.js') || file.endsWith('.css'))) {
      const filePath = path.join(outDir, file);
      if (fs.existsSync(filePath) && fs.lstatSync(filePath).isFile()) {
        fs.unlinkSync(filePath);
      }
    }
  });
  fs.unlinkSync(manifestPath);
}
