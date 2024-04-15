import argparse
import json
from pptx_handler.presentation_parser import parse_pptx_to_json

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Parse PowerPoint presentations to JSON")
    parser.add_argument("pptx_file", help="Path to the PowerPoint (.pptx) file")
    parser.add_argument("-o", "--output", default="parsed_module.json", help="Output JSON filename")
    args = parser.parse_args()

    json_data = parse_pptx_to_json(args.pptx_file)

    print(f"Final JSON structure has {len(json_data['slides'])} slides.")

    json_data['slides'] = [slide.to_dict() for slide in json_data['slides']]

    with open(args.output, 'w') as f:
        json.dump(json_data, f)

