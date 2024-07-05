import schedule
import time
from erp import fetch_data 

def actualizacion_diaria():
    schedule.every().day.at("00:00").do(fetch_data)

    while True:
        schedule.run_pending()
        time.sleep(1)

if __name__ == "__main__":
    actualizacion_diaria()
