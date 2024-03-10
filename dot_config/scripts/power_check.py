import subprocess
import os
import time

def ping_host(host):
    """
    Ping a host and return True if successful, False otherwise.
    """
    ping_cmd = ["ping","-W", "0.1", "-c", "1", host]
    try:
        subprocess.check_output(ping_cmd)
        return True
    except subprocess.CalledProcessError:
        return False

def main():
    host_to_ping = "192.168.1.88"
    router_to_ping = "192.168.1.1"
    failed_attempts = 0

    while True:
        if os.path.exists("/tmp/POWER_OUTAGE_KILLSWITCH"):
            if ping_host(host_to_ping):
                print('Successful ping')
                failed_attempts = 0
            else:
                print('Failed ping')
                failed_attempts += 1

            if failed_attempts >= 2 and ping_host(router_to_ping):
                os.system("systemctl suspend --force")
                # os.system("notify-send -u low -i '/home/itachi/.config/dunst/images/bell.png' 'Test' &")
                break
        else:
            print("POWER_OUTAGE_KILLSWITCH file not found. Ignoring the operation.")

        time.sleep(0.5)

if __name__ == "__main__":
    main()
