from time import sleep

import pyautogui
import pyperclip

shit = [
    '山不在高，',
    '有仙则名。',
    '水不在深，',
    '有龙则灵。',
    '斯是陋室，',
    '惟吾德馨。',
    '苔痕上阶绿，',
    '草色入帘青。',
    '谈笑有鸿儒，',
    '往来无白丁。',
    '可以调素琴，',
    '阅金经。',
    '无丝竹之乱耳，',
    '无案牍之劳形。',
    '南阳诸葛庐，',
    '西蜀子云亭。',
    '孔子云：何陋之有？',
]


def bullshit(src: str = '',
             times: int = 1,
             interval: float = 0.3,
             enter_after_cp: bool = True
             ) -> None:
    if src != '':
        try:
            with open(src) as f:
                global shit
                shit = f.readlines()
        except:
            ...

    pyautogui.hotkey('alt', 'tab')
    for i in range(times):
        for j in range(len(shit)):
            pyperclip.copy(shit[j])
            pyautogui.hotkey('ctrl', 'v')
            if enter_after_cp:
                pyautogui.hotkey('enter')
            sleep(interval)


if __name__ == '__main__':
    bullshit(src='', enter_after_cp=False)
