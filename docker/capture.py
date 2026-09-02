import os
from pathlib import Path

from playwright.sync_api import sync_playwright


URL = os.environ.get("CAPTURE_URL", "https://www.butler.works/ko/insight")
OUTPUT_DIR = Path(os.environ.get("OUTPUT_DIR", "/out"))


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(headless=True)
        page = browser.new_page(viewport={"width": 1440, "height": 1000}, device_scale_factor=1)
        page.goto(URL, wait_until="networkidle", timeout=90_000)
        page.screenshot(path=str(OUTPUT_DIR / "screenshot.png"), full_page=True)
        (OUTPUT_DIR / "rendered-text.txt").write_text(page.locator("body").inner_text(), encoding="utf-8")
        browser.close()


if __name__ == "__main__":
    main()
