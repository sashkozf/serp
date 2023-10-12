import requests
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time
import os
import telegram

# Replace YOUR_TELEGRAM_BOT_TOKEN with your actual bot token
telegram_bot_token = "5968492943:AAFYz21nADN4wDj8jXya8VIdTmykFCfzEN4"
chat_ids = ["343862506", "403678902"] # Replace with the chat IDs of the chats you want to send the message to

# Set up options for the Selenium webdriver
options = Options()
options.headless = True # Run the browser in headless mode, i.e. without a visible window
options.add_argument("--no-sandbox") # Bypass OS security model
options.add_argument("--disable-dev-shm-usage") # Overcome limited resource problems

# Set up the webdriver for Chrome
driver_path = "/usr/local/bin/chromedriver" # Replace with the actual path to your chromedriver executable
driver = webdriver.Chrome(options=options, executable_path=driver_path)

# Navigate to the API URL and wait for the page to load
url = "https://api.serpwow.com/search?api_key=9209AA9371DB477BBD0BBD642417EC00&q=%D0%BB%D0%B5%D1%81%D1%8C+%D0%BB%D0%BE%D0%B7%D0%BE%D0%B2%D1%81%D1%8C%D0%BA%D0%B8%D0%B9&engine=google&location=Ukraine&google_domain=google.com.ua&gl=ua&hl=uk&output=html&time_period=last_week"

driver.get(url)
time.sleep(5) # Wait for 5 seconds for the page to fully load

# Take a screenshot of the page and save it to a file
screenshot_file = "/mnt/operational/screenshot.png" # Replace with the actual path to the file where you want to save the screenshot
driver.save_screenshot(screenshot_file)

# Close the webdriver
driver.quit()

# Set up the Telegram API endpoint
telegram_api_url = "https://api.telegram.org/bot" + telegram_bot_token + "/sendPhoto"

# Send the screenshot to the specified chats using the Telegram bot
for chat_id in chat_ids:
    with open(screenshot_file, "rb") as f:
        response = requests.post(
            telegram_api_url,
            data={
                "chat_id": chat_id,
            },
            files={
                "photo": f,
            },
        )

        if response.status_code != 200:
            # Print an error message
            print(f"Error sending screenshot to chat {chat_id}: {response.status_code}")

# Send a message to the current chat IDs
telegram_bot = telegram.Bot(token=telegram_bot_token)
for chat_id in chat_ids:
    telegram_bot.send_message(chat_id=chat_id, text="Привіт! Ось найновіша інформація, яку я відшукав.")

# Delete the screenshot file
os.remove(screenshot_file)

