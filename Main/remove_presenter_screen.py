import pyautogui as py
import pywinauto


def get_open_windows():
   windows = []
   for i in py.getAllWindows():
      windows.append(i.title)
   return windows



def handle_window_manipulation():
      for i in get_open_windows():
         if i == "Presenter Display (Main Audience Output)":
            app = pywinauto.Application().connect(title="Presenter")
            window = app.window(best_match="Presenter")
            window.set_focus()
            py.press("f12")
            window.minimize()
            print("Done")
            return
      print("Presenter Screen Not Found")


if __name__ == "__main__":
    handle_window_manipulation()
