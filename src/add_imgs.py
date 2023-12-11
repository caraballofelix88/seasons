import json
from wand.image import Image
from wand.drawing import Drawing
from wand.color import Color


img_configs = {
    "header": {
        "width": 64,
        "height": 32,
        "font_size": 28,
        "font_weight": 100,
        "font": "YuMincho-+36p-Kana-Medium",
        "fill_color": "white",
        "stroke_color": "white",
    },
    "subheader": {
        "width": 64,
        "height": 32,
        "font_size": 24,
        "font_weight": 100,
        "font": "YuMincho-+36p-Kana-Medium",
        "fill_color": "green",
        "stroke_color": "green",
    },
    "romaji": {
        "width": 64,
        "height": 28,
        "font_size": 28,
        "font_weight": 100,
        "font": "YuMincho-+36p-Kana-Medium",
        "fill_color": "green",
        "stroke_color": "green",
    },
}


def generateBase64(str, config):
    img_width = config["font_size"] * len(str)
    with Image(background=None, width=img_width, height=config["height"]) as img:
        img.format = "png"
        with Drawing() as ctx:
            ctx.font = config["font"]
            ctx.font_weight = config["font_weight"]
            ctx.font_size = config["font_size"]  # 16px = 12pt (?)
            ctx.fill_color = Color(config["fill_color"])
            ctx.stroke_color = Color(config["stroke_color"])

            ctx.gravity = "center"

            img.annotate(str, ctx)
            img.trim()

        return img.data_url()


def main():
    with open("seasons.json", "r+") as file:
        seasons = json.load(file)

        for season in seasons:
            season["base64_str"] = generateBase64(season["name"], img_configs["header"])

            for ko in season["kos"]:
                ko["base64_str"] = generateBase64(ko["name"], img_configs["subheader"])

        file.seek(0)
        json.dump(seasons, file, indent=2, sort_keys=True)
        file.truncate()


main()
