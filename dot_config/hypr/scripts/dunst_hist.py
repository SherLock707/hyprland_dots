import subprocess
import json

def parse_dunstctl_history():
    # Run dunstctl history command
    command_output = subprocess.run(['dunstctl', 'history'], capture_output=True, text=True)

    # Check if the command was successful
    if command_output.returncode != 0:
        print(f"Error executing dunstctl history: {command_output.stderr}")
        return

    # Parse the JSON data from the command output
    try:
        data = json.loads(command_output.stdout)
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON data: {e}")
        return
    
    print(data)

    # Extract relevant information from the JSON data
    for entry in data.get('data', []):
        for notification in entry:
            appname = notification.get('appname', {}).get('data', '')
            icon_path = notification.get('icon_path', {}).get('data', '')
            summary = notification.get('summary', {}).get('data', '')
            body = notification.get('message', {}).get('data', '')

            # Print the extracted information
            print(f"Appname: {appname}")
            print(f"Icon Path: {icon_path}")
            print(f"Summary: {summary}")
            print(f"Body: {body}")
            print("\n" + "="*30 + "\n")

if __name__ == "__main__":
    parse_dunstctl_history()
