load("render.star", "render")
load("time.star", "time")
load("encoding/base64.star", "base64")
load("animation.star", "animation")

# [[[cog
# import cog
# import json
#
# with open('seasons.json', 'r') as file:
#   cog.outl('seasons = %s' % json.dumps(json.load(file), indent=2))
# cog.outl('### OUT ###')
# ]]]

### OUT ###
# [[[end]]]

def withinSeason(date, season):
    start, end = getSeasonDateRange(season)
    return date > start and date < end

def getSeasonDateRange(season):
    start = time.parse_time(season["start"])
    end = time.parse_time(season["end"])

    now = time.now()
    return time.time(month = start.month, day = start.day, year = now.year), time.time(month = end.month, day = end.day, year = now.year)

def main():
    today = time.now()

    current = {}
    current_ko = {}
    for season in seasons:
        if withinSeason(today, season):
            current = season
            for ko in current["kos"]:
                if withinSeason(today, ko):
                    current_ko = ko

    imgsrc = base64.decode(current["base64_str"].split(",")[1])
    ko_img_src = base64.decode(current_ko["base64_str"].split(",")[1])

    # adding set width scales down images to fit
    season = render.Box(child = render.Image(src = imgsrc, width = 64))
    ko = render.Box(child = render.Image(src = ko_img_src, width = 64))

    season_anim = animation.Transformation(
        child = season,
        duration = 100,
        delay = 0,
        origin = animation.Origin(0.5, 0.5),
        direction = "alternate",
        fill_mode = "forwards",
        keyframes = [
            animation.Keyframe(
                percentage = 0.0,
                transforms = [animation.Translate(0, -32)],
                curve = "ease_in_out",
            ),
            animation.Keyframe(
                percentage = 1.0,
                transforms = [animation.Translate(0, 0)],
            ),
        ],
    )

    ko_anim = animation.Transformation(
        child = ko,
        duration = 100,
        delay = 0,
        origin = animation.Origin(0.5, 0.5),
        direction = "alternate",
        fill_mode = "forwards",
        keyframes = [
            animation.Keyframe(
                percentage = 0.0,
                transforms = [animation.Translate(0, 0)],
                curve = "ease_in_out",
            ),
            animation.Keyframe(
                percentage = 1.0,
                transforms = [animation.Translate(0, 32)],
            ),
        ],
    )

    # TODO: function for generating animated color backgrounds
    animated_background = render.Animation(
        children = [
            render.Box(width = 64, height = 32, color = "#300"),
            render.Box(width = 64, height = 32, color = "#310"),
            render.Box(width = 64, height = 32, color = "#320"),
            render.Box(width = 64, height = 32, color = "#330"),
            render.Box(width = 64, height = 32, color = "#340"),
            render.Box(width = 64, height = 32, color = "#350"),
            render.Box(width = 64, height = 32, color = "#360"),
        ],
    )

    return render.Root(
        child = render.Box(
            color = "#0057BA",
            child = render.Stack(
                children = [animated_background, season_anim, ko_anim],
            ),
        ),
    )
