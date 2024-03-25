from flask import Flask, request
from google.cloud import storage
import numpy as np
#import io
from tensorflow.keras.models import load_model
from keras.models import load_model
import librosa

app = Flask(__name__)
'''
storage_client = storage.Client.from_service_account_json('sdgp-cs-39-empowerme-4f7091c30cea.json')


# Define custom objects if needed
custom_objects = {'Adam': Adam}

# Load the model with custom objects
model = load_model('E:/IIT/Level_5_year_2/new github commit 21-03-2024/ML_model_G_Cloud_deployment_with_CI_CD_Pipeline/empowerme-ml-deployment/tmpml/EmpowerMe_emotion_model.h5', custom_objects=custom_objects)
'''
'''
def download_blob(bucket_name, source_blob_name, destination_file_name):
    """Downloads a blob from the bucket."""
    storage_client = storage.Client()
    try:
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(source_blob_name)
        blob.download_to_filename(destination_file_name)
        print(f"Blob {source_blob_name} downloaded to {destination_file_name} successfully.")
    except Exception as e:
        print(f"Error downloading blob {source_blob_name}: {e}")
'''

#download_blob('emotion_ml_model', 'EmpowerMe_emotion_model.h5', '/tmpml/EmpowerMe_emotion_model.h5')
#model = load_model('/tmpml/EmpowerMe_emotion_model.h5')
'''
def download_model_from_gcs(bucket_name, source_blob_name):
    """Downloads a model from Google Cloud Storage."""
    try:
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(source_blob_name)
        model_bytes = blob.download_as_string()
        return model_bytes
    except Exception as e:
        print(f"Error downloading model from GCS: {e}")
        return None

# Usage
bucket_name = "emotion_ml_model"
source_blob_name = "EmpowerMe_emotion_model.h5"
model_bytes = download_model_from_gcs(bucket_name, source_blob_name)

# Now you can load the model directly from memory
if model_bytes:
    model = load_model(io.BytesIO(model_bytes))
    print("Model loaded successfully!")
else:
    print("Error: Model download failed.")

'''

# Define custom objects


#model = load_model('E:/IIT/Level_5_year_2/new github commit 21-03-2024/ML_model_G_Cloud_deployment_with_CI_CD_Pipeline/empowerme-ml-deployment/tmpml/EmpowerMe_emotion_model.h5')

# Load the model with custom objects
model = load_model('E:/IIT/sdgp code/ml_flask_app_new/tmpml/EmpowerMe_emotion_model.h5', compile=False)

@app.route('/predict', methods=['POST'])
def predict():

    # Get audio file and save it
    audio_file = request.files["file"]
    file_name = "temp.wav"
    audio_file.save(file_name)
    #audio_data = audio_file.read()  # Read audio data directly into memory

    # Load audio file and convert it into Mel spectrogram
    audio, _ = librosa.load(file_name, sr=None)
    #audio, _ = librosa.load(io.BytesIO(audio_data), sr=None)
    mel_spec = librosa.feature.melspectrogram(y=audio, sr=_, n_mels=64)
    mel_spec_db = librosa.power_to_db(mel_spec, ref=np.max)
    mel_spec_db_fixed = librosa.util.fix_length(mel_spec_db, size=960)
    mel_spec_db_fixed = np.expand_dims(mel_spec_db_fixed, axis=-1)

    # Predict the class
    prediction = model.predict(np.array([mel_spec_db_fixed]))

    # Get the predicted class ID
    class_id = int(np.argmax(prediction))

    # Get the emotion label corresponding to the class ID
    #emotion_label = label_mapping.get(class_id, 'Unknown')

    # Return the predicted emotion label
    #return emotion_label

    # Print the predicted class ID in the console
    print("Predicted class ID:", class_id)
    
    return str(class_id)

    # Send back the result as json
    #return {"class_id": int(np.argmax(prediction))}

@app.route('/', methods=['GET'])
def home():
    return "Welcome to empowerme emotion recognition model!"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=False)
