TEAM_LOGOS = {
    "ANA": "ducks_glance_tiny.png",
    "CGY": "flames_glance_tiny.png",
    "EDM": "oilers_glance_tiny.png",
    "LAK": "kings_glance_tiny.png",
    "SJS": "sharks_glance_tiny.png",
    "SEA": "kraken_glance_tiny.png",
    "VAN": "canucks_glance_tiny.png",
    "VGK": "golden_knights_glance_tiny.png",
    "CHI": "blackhawks_glance_tiny.png",
    "COL": "avalanche_glance_tiny.png",
    "DAL": "stars_glance_tiny.png",
    "MIN": "wild_glance_tiny.png",
    "NSH": "predators_glance_tiny.png",
    "STL": "blues_glance_tiny.png",
    "UTA": "mammoth_glance_tiny.png",
    "WPG": "jets_glance_tiny.png",
}


TEAM_ACCENTS = {
    "ANA": "#F47A38",
    "CGY": "#D2001C",
    "EDM": "#FF4C00",
    "LAK": "#A2AAAD",
    "SJS": "#006D75",
    "SEA": "#68A2B9",
    "VAN": "#00843D",
    "VGK": "#B4975A",
    "CHI": "#CF0A2C",
    "COL": "#6F263D",
    "DAL": "#006847",
    "MIN": "#154734",
    "NSH": "#FFB81C",
    "STL": "#002F87",
    "UTA": "#69B3E7",
    "WPG": "#004C97",
}


def get_nhl_standings():
    resp = http.get(
        "https://api-web.nhle.com/v1/standings/2026-04-17",
        ttl_seconds=300,
    )

    if resp["status_code"] != 200:
        return None

    if resp["json"] == None:
        return None

    return resp["json"]


def get_pacific(rank):
    data = get_nhl_standings()

    if data == None:
        return None

    for team in data["standings"]:
        if team["conferenceAbbrev"] == "W":
            if team["divisionAbbrev"] == "P":
                if team["divisionSequence"] == rank:
                    return team

    return None


def get_central(rank):
    data = get_nhl_standings()

    if data == None:
        return None

    for team in data["standings"]:
        if team["conferenceAbbrev"] == "W":
            if team["divisionAbbrev"] == "C":
                if team["divisionSequence"] == rank:
                    return team

    return None


def get_west_wildcard(rank):
    data = get_nhl_standings()

    if data == None:
        return None

    for team in data["standings"]:
        if team["conferenceAbbrev"] == "W":
            if team["wildcardSequence"] == rank:
                return team

    return None


def get_west_hunt(rank):
    data = get_nhl_standings()

    if data == None:
        return None

    teams = []

    for team in data["standings"]:
        if team["conferenceAbbrev"] == "W":
            if team["divisionSequence"] > 3:
                if team["wildcardSequence"] != 1:
                    if team["wildcardSequence"] != 2:
                        teams.append(team)

    teams = sorted(
        teams,
        key=lambda team: team["conferenceSequence"],
    )

    if rank <= len(teams):
        return teams[rank - 1]

    return None


def draw_header(c):
    c.text(
        "TEAM",
        19,
        0,
        font="4x5",
        color="white",
    )

    c.text(
        "GP",
        51,
        0,
        font="4x5",
        color="white",
    )

    c.text(
        "W",
        72,
        0,
        font="4x5",
        color="white",
    )

    c.text(
        "L",
        89,
        0,
        font="4x5",
        color="white",
    )

    c.text(
        "OTL",
        104,
        0,
        font="4x5",
        color="white",
    )

    c.text(
        "PTS",
        137,
        0,
        font="4x5",
        color="yellow",
    )

    c.text(
        "RW",
        168,
        0,
        font="4x5",
        color="yellow",
    )

    c.line(
        0,
        6,
        181,
        6,
        "white",
    )


def draw_team_row(c, team, rank, y):
    if team == None:
        return

    abbreviation = team["teamAbbrev"]["default"]
    logo = TEAM_LOGOS[abbreviation]
    accent = TEAM_ACCENTS[abbreviation]

    c.rect(
        0,
        y,
        2,
        y + 6,
        fill=accent,
    )

    c.text(
        str(rank),
        4,
        y,
        font="4x5",
        color=accent,
    )

    c.image(
        logo,
        10,
        y - 1,
    )

    c.text(
        abbreviation,
        19,
        y,
        font="5x7",
        color="white",
    )

    c.text(
        str(team["gamesPlayed"]),
        51,
        y,
        font="5x7",
        color="white",
    )

    c.text(
        str(team["wins"]),
        72,
        y,
        font="5x7",
        color="white",
    )

    c.text(
        str(team["losses"]),
        89,
        y,
        font="5x7",
        color="white",
    )

    c.text(
        str(team["otLosses"]),
        104,
        y,
        font="5x7",
        color="white",
    )

    c.text(
        str(team["points"]),
        137,
        y,
        font="5x7",
        color="yellow",
    )

    c.text(
        str(team["regulationWins"]),
        168,
        y,
        font="5x7",
        color="yellow",
    )


def draw_separator(c, team, y):
    if team == None:
        c.line(
            0,
            y,
            181,
            y,
            "white",
        )
        return

    abbreviation = team["teamAbbrev"]["default"]
    accent = TEAM_ACCENTS[abbreviation]

    c.line(
        0,
        y,
        181,
        y,
        accent,
    )


def western_conference(c, ctx):
    c.fill("black")

    c.image(
        "western_conference_title_glance.png",
        0,
        0,
    )


def pacific_title(c, ctx):
    c.fill("black")

    c.image(
        "pacific_division_glance.png",
        0,
        0,
    )


def pacific_standings(c, ctx):
    c.fill("black")

    team1 = get_pacific(1)
    team2 = get_pacific(2)
    team3 = get_pacific(3)

    draw_header(c)

    draw_team_row(
        c,
        team1,
        1,
        8,
    )

    draw_separator(
        c,
        team1,
        15,
    )

    draw_team_row(
        c,
        team2,
        2,
        16,
    )

    draw_separator(
        c,
        team2,
        23,
    )

    draw_team_row(
        c,
        team3,
        3,
        24,
    )


def central_title(c, ctx):
    c.fill("black")

    c.image(
        "central_division_glance.png",
        0,
        0,
    )


def central_standings(c, ctx):
    c.fill("black")

    team1 = get_central(1)
    team2 = get_central(2)
    team3 = get_central(3)

    draw_header(c)

    draw_team_row(
        c,
        team1,
        1,
        8,
    )

    draw_separator(
        c,
        team1,
        15,
    )

    draw_team_row(
        c,
        team2,
        2,
        16,
    )

    draw_separator(
        c,
        team2,
        23,
    )

    draw_team_row(
        c,
        team3,
        3,
        24,
    )


def west_wildcard(c, ctx):
    c.fill("black")

    c.image(
        "west_wildcard_blue_glance.png",
        0,
        0,
    )


def west_wc(c, ctx):
    c.fill("black")

    team1 = get_west_wildcard(1)
    team2 = get_west_wildcard(2)

    draw_header(c)

    draw_team_row(
        c,
        team1,
        1,
        10,
    )

    draw_separator(
        c,
        team1,
        19,
    )

    draw_team_row(
        c,
        team2,
        2,
        22,
    )


def west_hunt(c, ctx):
    c.fill("black")

    team1 = get_west_hunt(1)
    team2 = get_west_hunt(2)
    team3 = get_west_hunt(3)

    draw_header(c)

    draw_team_row(
        c,
        team1,
        1,
        8,
    )

    draw_separator(
        c,
        team1,
        15,
    )

    draw_team_row(
        c,
        team2,
        2,
        16,
    )

    draw_separator(
        c,
        team2,
        23,
    )

    draw_team_row(
        c,
        team3,
        3,
        24,
    )
