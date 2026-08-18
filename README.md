# PowerShell Toolbox

A collection of PowerShell utility scripts for system optimization, file maintenance, and workflow automation.

## Scripts

### Optimize-PowerPoint.ps1

Recursively scans a target directory for Microsoft PowerPoint (.pptx) files and compresses embedded media and assets using Node.js image processing primitives (sharp). Safely overwrites the original file only if the resulting compressed payload is smaller.

#### Prerequisites

- **Node.js** (v18+)
- **7-Zip** installed in standard system paths (C:\Program Files\7-Zip)
- PowerPoint Compressor package installed locally at $env:USERPROFILE\github\powerpoint-compressor

#### Usage

\\\powershell
# Run in current working directory
.\Optimize-PowerPoint.ps1

# Run against a specific directory
.\Optimize-PowerPoint.ps1 -Path "$env:USERPROFILE\Documents"

# Run and strip embedded video streams
.\Optimize-PowerPoint.ps1 -Path "$env:USERPROFILE\Desktop" -RemoveVideos
\\\


## License

[MIT](LICENSE)
