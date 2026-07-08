#!/usr/bin/env node

const fs = require('fs-extra');
const path = require('path');
const { execSync } = require('child_process');

// Get comprehensive image data using Nix and Docker
function getComprehensiveImageData() {
    const repoRoot = path.join(__dirname, '..', '..');
    process.chdir(repoRoot);
    
    const images = [];
    
    try {
        // Get discovered images from Nix
        const discoveredImages = JSON.parse(
            execSync('nix eval --json .#discoveredImages', { encoding: 'utf8' })
        );
        
        for (const imageName of discoveredImages) {
            console.log(`Processing ${imageName}...`);
            
            const imageData = {
                name: imageName,
                version: 'latest',
                size: 'Not built',
                buildDate: 'unknown',
                tags: ['latest'],
                hasTest: fs.existsSync(path.join('images', imageName, 'test.nix')),
                nixPath: `images/${imageName}/default.nix`
            };
            
            // Resolve version the SAME way build-and-push tags images:
            // getPackageVersion (lib/versions.nix) → the image's .imageTag →
            // "latest". The old `.config.Labels."...version"` eval FAILS for
            // nix2container images (their .config isn't an evaluable attr), so
            // every image fell through to "latest" even when published with a
            // real version tag. This was the root cause of the huge "latest"
            // count on the catalog.
            try {
                let version = execSync(
                    `nix eval --raw --impure --expr '(import ./lib/versions.nix { pkgs = import (builtins.getFlake (toString ./.)).inputs.nixpkgs { system = builtins.currentSystem; config.allowUnfree = true; }; }) "${imageName}"' 2>/dev/null || echo ""`,
                    { encoding: 'utf8' }
                ).trim();
                if (!version || version === 'latest') {
                    const tag = execSync(
                        `nix eval --raw .#"${imageName}".imageTag 2>/dev/null || echo ""`,
                        { encoding: 'utf8' }
                    ).trim();
                    version = tag.replace(/^v/, '');
                }
                if (version && version !== 'latest') {
                    imageData.version = version;
                    imageData.tags = ['latest', version];
                }
            } catch (error) {
                console.warn(`Could not get version for ${imageName}`);
            }
            
            // Try to get Docker image info if available
            try {
                const dockerInfo = execSync(
                    `docker images --format "{{.Size}}\\t{{.CreatedAt}}" ${imageName}:latest 2>/dev/null | head -1`,
                    { encoding: 'utf8' }
                ).trim();
                
                if (dockerInfo) {
                    const [size, createdAt] = dockerInfo.split('\t');
                    imageData.size = size;
                    imageData.buildDate = createdAt;
                }
            } catch (error) {
                // Image not built locally
            }
            
            images.push(imageData);
        }
        
        // Write to JSON file for website
        const outputPath = path.join(__dirname, '..', 'public', 'images-data.json');
        fs.writeFileSync(outputPath, JSON.stringify(images, null, 2));
        
        console.log(`✅ Updated image data for ${images.length} images`);
        return images;
        
    } catch (error) {
        console.error('Error updating image data:', error);
        process.exit(1);
    }
}

// Run if called directly
if (require.main === module) {
    getComprehensiveImageData();
}

module.exports = { getComprehensiveImageData };