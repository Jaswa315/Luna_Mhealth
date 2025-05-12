import argparse
from googleapiclient.discovery import build
from google.oauth2 import service_account
import google.auth.transport.requests
from googleapiclient.http import MediaFileUpload

"""
Updates the content of a file in Google drive

Arguements
----------
credFile : Path to the credential file to use for the upload
driveFileID : ID of the file to update in Google drive
newFilePath : path to the the new file to use as the content update for Google drive

"""

# Resources for google apis used in this script
# https://developers.google.com/workspace/drive/api/quickstart/python
# https://developers.google.com/workspace/drive/api/guides/manage-uploads

def creates_creds(cred_file_loc):
  creds = service_account.Credentials.from_service_account_file(
      cred_file_loc,  
      scopes=['https://www.googleapis.com/auth/drive']  
  )
  auth_req = google.auth.transport.requests.Request()
  creds.refresh(auth_req)
  return creds

def upload_file(creds, path_to_file, file_id, new_drive_file_name, mimetype="application/zip"):
  #create drive api client
  file_metadata = {"name": new_drive_file_name}
  service = build("drive", "v3", credentials=creds)
  media = MediaFileUpload(path_to_file, mimetype=mimetype)
  service.files() \
  .update(fileId = file_id, body=file_metadata, media_body=media) \
  .execute()
  
def get_arguments():
  parser = argparse.ArgumentParser()
  parser.add_argument("credFile") # arguement for locaton of credential file
  parser.add_argument("driveFileID") # ID in google drive of file to update
  parser.add_argument("newFilePath") # location of new file to update
  parser.add_argument("updatedDriveFileName")
  return parser.parse_args()
  

if __name__ == "__main__":
  args = get_arguments()
  creds = creates_creds(args.credFile)
  upload_file(creds, args.newFilePath, args.driveFileID, args.updatedDriveFileName)