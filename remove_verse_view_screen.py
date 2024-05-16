import pyautogui as py
import pywinauto


def get_open_windows():
   windows = []
   for i in py.getAllWindows():
      windows.append(i.title)
   return windows


def remove_verse_view_screen():
      for i in get_open_windows():
         if i == "Presentation Window 3":
            app = pywinauto.Application().connect(title="VerseVIEW 8.4.0")
            window = app.window(best_match="VerseVIEW 8.4.0")
            window.set_focus()
            py.press("esc")
            window.minimize()
            print("Done")
            return
      print("No Verse View Screen Found")
      
if __name__ == "__main__":
    remove_verse_view_screen()