from email.message import EmailMessage
from smtplib import SMTP

TO_ADDRESS = 
MODULE_NAME = 

def send_email(message):
    """utility function to send an email with results from a training run"""
    message_string = '\n'.join(message)
    recipients = [TO_ADDRESS]
    msg = EmailMessage()
    msg['Subject'] = 'Finished training ' + MODULE_NAME
    msg['From'] = 'someserver@technion.ac.il'
    msg['To'] = ', '.join(recipients)
    msg.set_content(message_string)
    sender = SMTP('localhost')
    sender.send_message(msg)
    sender.quit()
