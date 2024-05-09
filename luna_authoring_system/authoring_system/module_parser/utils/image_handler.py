import os
import shutil
from ...config import BASE_IMAGE_DIR

class ImageHandler:
    def __init__(self, base_image_dir=BASE_IMAGE_DIR):
        self.base_image_dir = base_image_dir
        os.makedirs(self.base_image_dir, exist_ok=True)

    def save_image(self, image_data, slide_num, image_name):
        image_subdir = os.path.join(self.base_image_dir, f'slide_{slide_num}')
        os.makedirs(image_subdir, exist_ok=True)
        image_filename = f"{image_name}.png"  # Assuming PNG format for now
        image_path = os.path.join(image_subdir, image_filename)

        with open(image_path, 'wb') as f:
            f.write(image_data)

        return image_path

    def delete_images(self):
        shutil.rmtree(self.base_image_dir, ignore_errors=True)  
