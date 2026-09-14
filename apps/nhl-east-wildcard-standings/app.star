TEAM_LOGOS = {
    "BOS": "bruins_glance_tiny.png",
    "BUF": "sabres_glance_tiny.png",
    "CAR": "hurricanes_glance_tiny.png",
    "CBJ": "bluejackets_glance_tiny.png",
    "DET": "redwings_glance_tiny.png",
    "FLA": "panthers_glance_tiny.png",
    "MTL": "canadiens_glance_tiny.png",
    "NJD": "devils_glance_tiny.png",
    "NYI": "islanders_glance_tiny.png",
    "NYR": "rangers_glance_tiny.png",
    "OTT": "senators_glance_tiny.png",
    "PHI": "flyers_glance_tiny.png",
    "PIT": "penguins_glance_tiny.png",
    "TBL": "lightning_glance_tiny.png",
    "TOR": "maple_leafs_glance_tiny.png",
    "WSH": "capitals_glance_tiny.png",
}


TEAM_ACCENTS = {
    "BOS": "yellow",
    "BUF": "blue",
    "CAR": "red",
    "CBJ": "blue",
    "DET": "red",
    "FLA": "red",
    "MTL": "red",
    "NJD": "red",
    "NYI": "blue",
    "NYR": "blue",
    "OTT": "red",
    "PHI": "orange",
    "PIT": "yellow",
    "TBL": "blue",
    "TOR": "blue",
    "WSH": "red",
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


def get_metro(rank):
    data = get_nhl_standings()

    if data == None:
        return None

    for team in data["standings"]:
        if team["conferenceAbbrev"] == "E":
            if team["divisionAbbrev"] == "M":
                if team["divisionSequence"] == rank:
                    return team

    return None


def get_atlantic(rank):
    data = get_nhl_standings()

    if data == None:
        return None

    for team in data["standings"]:
        if team["conferenceAbbrev"] == "E":
            if team["divisionAbbrev"] == "A":
                if team["divisionSequence"] == rank:
                    return team

    return None


def get_east_wildcard(rank):
    data = get_nhl_standings()

    if data == None:
        return None

    for team in data["standings"]:
        if team["conferenceAbbrev"] == "E":
            if team["wildcardSequence"] == rank:
                return team

    return None


def get_east_hunt(rank):
    data = get_nhl_standings()

    if data == None:
        return None

    teams = []

    for team in data["standings"]:
        if team["conferenceAbbrev"] == "E":
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

    if abbreviation == "PHI":
        c.rect(
            10,
            y - 1,
            17,
            y + 6,
            fill="white",
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


def eastern_conference(c, ctx):
    c.fill("black")

    c.image(
        "eastern_conference_title_glance.png",
        0,
        0,
    )


def metro_title(c, ctx):
    c.fill("black")

    c.image(
        "metropolitan_division_exact_style.png",
        0,
        0,
    )


def metro_standings(c, ctx):
    c.fill("black")

    team1 = get_metro(1)
    team2 = get_metro(2)
    team3 = get_metro(3)

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


def atlantic_title(c, ctx):
    c.fill("black")

    c.image(
        "atlantic_division_no_grey_line.png",
        0,
        0,
    )


def atlantic_standings(c, ctx):
    c.fill("black")

    team1 = get_atlantic(1)
    team2 = get_atlantic(2)
    team3 = get_atlantic(3)

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


def east_wildcard(c, ctx):
    c.fill("black")

    c.image(
        "east_wildcard_red_glance.png",
        0,
        0,
    )


def east_wc(c, ctx):
    c.fill("black")

    team1 = get_east_wildcard(1)
    team2 = get_east_wildcard(2)

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


def east_hunt(c, ctx):
    c.fill("black")

    team1 = get_east_hunt(1)
    team2 = get_east_hunt(2)
    team3 = get_east_hunt(3)

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