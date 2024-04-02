# Luna Authoring System (ongoing)

The Luna Authoring System is a comprehensive tool designed to facilitate the conversion, validation, and packaging of educational content modules. This system enables the seamless transformation of PowerPoint presentations into interactive learning modules, ensuring content validity and ease of distribution.

## Project Structure

- **module_parser**: Converts PowerPoint (.pptx) files into structured JSON formats.
- **module_validator**: Validates the generated JSON modules against predefined criteria to ensure content quality and standard compliance.
- **package_builder**: Bundles the JSON modules along with associated media files and metadata into a distributable content package.
- **data**: Stores output data including parsed images and modules.
- **samples**: Contains sample PowerPoint files for testing and demonstration purposes.
- **tests**: Includes tests for ensuring code reliability and functionality across updates.

## Setup and Installation
Ensure Python 3.x is installed on your system. Additional dependencies are required for the module_parser component, which can be installed via pip:

```bash
pip install -r requirements.txt
```

# Usage

## Parsing PowerPoint Files
Navigate to the `module_parser` directory and execute the `main.py` script, specifying the path to your PowerPoint file and the desired output location for the JSON module:

```bash
python main.py -i <input_file> -o <output_dir>
```

## Example

```bash
python3 main.py ../../samples/Luna_sample_module.pptx -o ../../data/parsed_ir_module/parsed_output.json
```

## Validating Modules
Instructions on using the `module_validator` component will be added here.

## Building Content Packages
Instructions on using the `package_builder` component will be added here.

# Contributing
Contributions to the Luna Authoring System are welcome. Whether you're fixing bugs, adding new features, or improving documentation, please feel free to make a pull request.

## License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.