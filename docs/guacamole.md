# Copy and Paste in and out Guacamole
Apache Guacamole serves as a proxy to provide clientless access to other servers. The copy paste function is achieved through browser.

## Guacamole Menu
The guacamole menu is a sidebar which is hidden.

1. On a Windows device with an external keyboard, the guacamole menu is displayed by pressing **Ctrl+Alt+Shift**

2. On a Mac device with an external keyboard, the guacamole menu is displayed by pressing **Ctrl+Command+Shift**

![Rapi](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/guacamole-window.png)
3. On a device that doesn’t have a keyboard, e.g. mobile or touchscreen device, the guacamole menu is displayed by swiping right from the left edge of the screen.

To Hide the guacamole menu, press **Ctrl+Alt+Shift/ Ctrl+Command+Shift** or swipe left across the screen again.
## Guacamole Use
The Clipboard text area functions as an interface between the remote clipboard and local clipboard.

1. Text from the local clipboard can be pasted into the text area, and the text is sent to the remote clipboard.

![Rapi](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/guacamole-copy-to-rdp.png)
2. After the text is copied to the remote clipboard, the Guacamole menu can be closed.

The text from the clipboard can be pasted in the desired location.

![Rapi](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/guacamole-copy-to-rdp2.png)
3. Similarly, copying text from the remote desktop sends the text to the Clipboard text area on the Guacamole Menu, which can then be copied to the local clipboard. 

![Rapi](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/guacamole-copy-from-rdp.png)