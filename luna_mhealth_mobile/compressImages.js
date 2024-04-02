const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

const sourceFolder = 'test_media_compressed';
const sizeThreshold = 50 * 1024; // Size threshold in bytes (200KB)

fs.readdir(sourceFolder, (err, files) => {
    if (err) {
        console.error("Error reading the directory:", err);
        return;
    }

    files.forEach(file => {
        const sourceFilePath = path.join(sourceFolder, file);
        const destFilePath = path.join(sourceFolder, path.parse(file).name + '.webp');

        if (file.toLowerCase().endsWith('.png') || file.toLowerCase().endsWith('.jpg') || file.toLowerCase().endsWith('.jpeg')) {
            fs.stat(sourceFilePath, (err, stats) => {
                if (err) {
                    console.error("Error reading the file stats:", err);
                    return;
                }

                if (stats.size > sizeThreshold) {
                    sharp(sourceFilePath)
                        .toFormat('webp', { quality: 80 })
                        .toFile(destFilePath, (err) => {
                            if (err) {
                                console.error("Error compressing the file:", err);
                                return;
                            }
                            fs.unlinkSync(sourceFilePath); // Remove the original file
                            console.log(`Compressed and replaced: ${file} with ${path.parse(file).name}.webp`);
                        });
                } else {
                    console.log(`Skipped (file size below threshold): ${file}`);
                }
            });
        }
    });
});
