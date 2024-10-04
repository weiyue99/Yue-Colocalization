import pandas as pd
from tkinter import Tk
from tkinter.filedialog import askopenfilename

# Function to open file dialog and select the file
def select_file():
    root = Tk()
    root.withdraw()  # We don't want a full GUI, so keep the root window from appearing
    file_path = askopenfilename(title="Select the CSV file", filetypes=[("CSV Files", "*.csv")])
    return file_path

# Load your CSV file after selecting it
file_path = select_file()
if not file_path:
    print("No file selected. Exiting.")
    exit()

data = pd.read_csv(file_path)

# Extract relevant columns for further processing
filtered_data = data[['Image A', 'Thresholded M2']]

# Identify the image stacks based on "Image A" column by checking when the series changes
filtered_data['Image Stack'] = filtered_data['Image A'].apply(lambda x: x.split(' ')[0])

# Group the data by the Image Stack and check for z-slices with positive "Thresholded M2" values
positive_ranges = []

for image_stack, group in filtered_data.groupby('Image Stack'):
    # Check for positive Thresholded M2 values
    group = group.reset_index(drop=True)
    positive_slices = group[group['Thresholded M2'] > 0].index.tolist()
    
    if positive_slices:
        # Find the range of positive z-slices
        first_z = positive_slices[0] + 1
        last_z = positive_slices[-1] + 1
        positive_ranges.append({
            'Image Stack': image_stack,
            'Positive Z-slices Start': first_z,
            'Positive Z-slices End': last_z
        })

# Convert to DataFrame
positive_ranges_df = pd.DataFrame(positive_ranges)

# Save the result to a CSV file (optional)
positive_ranges_df.to_csv('positive_z_slices_ranges.csv', index=False)

# Display the result (optional)
print(positive_ranges_df)
