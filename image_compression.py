import os
from PIL import Image

def compress_image(source_filepath, dest_filepath, original_size):
    """
    Compresses an image with dynamic quality based on original file size.
    """
    if original_size > 2 * 1024 * 1024:  # Greater than 5MB
        quality = 30
    elif original_size > 1 * 1024 * 1024:  # Between 1MB and 5MB
        quality = 60
    else:  # Less than 1MB
        quality = 80

    with Image.open(source_filepath) as img:
        if img.mode != 'RGB':
            img = img.convert('RGB')
        # img.save(dest_filepath, optimize=True, quality=quality)
        img.save(dest_filepath, format='webp', optimize=True, quality=80)

def main():
    source_folder = 'test_media'
    target_folder = 'test_media_compressed'
    size_threshold = 50 * 1024  # Size threshold in bytes (50KB)

    if not os.path.exists(target_folder):
        os.makedirs(target_folder)

    for filename in os.listdir(source_folder):
        source_filepath = os.path.join(source_folder, filename)
        if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
            file_size = os.path.getsize(source_filepath)
            if file_size > size_threshold:
                # dest_filepath = os.path.join(target_folder, filename)
                base_filename, file_extension = os.path.splitext(filename)
                dest_filepath = os.path.join(target_folder, base_filename + '.webp')
                compress_image(source_filepath, dest_filepath, file_size)
                print(f"Compressed and saved: {base_filename}.webp")
            else:
                print(f"Skipped (file size below threshold): {filename}")

if __name__ == "__main__":
    main()
