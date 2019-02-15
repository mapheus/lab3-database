#!/usr/bin/env_python

import json
import re
import requests


HOST="localhost"
PORT=7007


def url(resource):
    return "http://{HOST}:{PORT}{resource}".format(HOST=HOST, PORT=PORT, resource=resource)


def response_to_dicts(r):
    return (dict(d) for d in r.json()['data'])


def abort(msg):
    print("Error: {msg}".format(msg=msg))
    exit(1)


def check_ping():
    resource = url('/ping')
    r = requests.get(resource)
    if r.text.strip() == 'pong':
        print("ping OK")
    else:
        abort('curl -X GET {resource} does not return pong'.format(resource=resource))


def check_reset():
    resource = url('/reset')
    r = requests.post(resource)
    if r.text.strip() == 'OK':
        print("reset OK")
    else:
        abort('curl -X POST {resource} does not return OK'.format(resource=resource))
    

def check_all_movies():
    try:
        r = requests.get(url('/movies'))
        found = response_to_dicts(r)
        print("======== Found movies ========")
        for d in found:
            title = d['title']
            year = d['year']
            print("{title} ({year})".format(title=title, year=year))
        print("==============================")
    except:
        abort("curl -X GET {url} does not work".format(url=url('/movies')))


def check_movie_title(title, year):
    resource = url('/movies?title={title}&year={year}'.format(title=title, year=year))
    try:
        r = requests.get(resource)
        found = list(response_to_dicts(r))
        if len(found) != 1:
            abort("curl -X GET {resource} returns {len} movies (should have been 1)".format(resource=resource, len=len(found)))
        for d in found:
            assert d['title'] == title
            assert d['year'] == year
        print("Could get {title} ({year}) using title and year".format(title=title, year=year))
    except:
        abort("curl -X GET {resource} does not work".format(resource=resource))


def check_movie_imdb(imdb_key):
    resource = url('/movies/{imdb_key}'.format(imdb_key=imdb_key))
    try:
        r = requests.get(resource)
        found = list(response_to_dicts(r))
        if len(found) != 1:
            abort("{resource} returns {len} movies (should have been 1)".format(resource=resource,len=len(found)))
        for d in found:
            title = d['title']
            year = d['year']
        print("Could get {title} ({year}) using imdb-key".format(title=title, year=year))
    except:
        abort("curl -X GET {resource} does not work".format(resource=resource))


def add_performances(imdb, theaters, dates):
    print("======== Adding performances ========")
    for theater in theaters:
        for date in dates:
            resource = url('/performances?imdb={imdb}&theater={theater}&date={date}&time=19:30'.format(imdb=imdb, theater=theater, date=date))
            try:
                r = requests.post(resource)
                m = re.search('/performances/(.+)', r.text.strip())
                if m:
                    print("{imdb} at {theater} on {date}: {m.group(1)}".format(imdb=imdb, theater=theater, date=date))
            except:
                abort("curl -X POST {url} does not work".format(url=resource))
    print("-------------------------------------")
    print("See tickets at:")
    print("curl -GET {url}".format(url=url('/performances')))
    print("=====================================")


def buy_tickets(user_id):
    print("======== Buying tickets ========")
    try:
        for _ in range(2):
            resource = url('/performances')
            r = requests.get(resource)
            performance = next(p for p in response_to_dicts(r) if p['theater'] == 'Kino' and p['remaining'] > 0)
            perf_id = performance['performanceId']
            seats_left = performance['remaining']
            print("================================")
            print("Buying tickets to {perf} on {perf2}".format(perf=performance['title'],perf2=performance['date']))
            buy_url = url('/tickets?user={user_id}&performance={perf_id}&pwd=dobido'.format(user_id=user_id, perf_id=perf_id))
            print("--------------------------------")
            print(buy_url)
            print(seats_left)
            print("--------------------------------")
            for _ in range(seats_left):
                r = requests.post(buy_url)
                print(r.text)
                m = re.search('/tickets/(.+)', r.text.strip())
                if not m:
                    abort('Got no ticket when trying to buy available seat')
            # now fail once:
            r = requests.post(buy_url)
            if not r.text.strip() == "No tickets left":
                abort("Could by too many tickets")
        print("================================")
    except:
        abort('Got error when trying to buy tickets')


def see_tickets(user_id):
    try:
        resource = url('/customers/{user_id}/tickets'.format(user_id=user_id))
        print("curl -X GET {resource}".format(resource=resource))
        r = requests.get(resource)
        print(r.text)
    except:
        abort("Could not see the tickets bought by {user_id}".format(user_id=user_id))


def main():
    check_ping()
    check_reset()
    check_all_movies()
    check_movie_title("Spotlight", 2015)
    check_movie_imdb("tt5580390")
    add_performances(
        'tt5580390',
        ['Kino', 'Skandia'],
        ['2019-02-22', '2019-02-23']
    )
    add_performances(
        'tt2562232',
        ['Kino', 'Skandia'],
        ['2019-02-24', '2019-02-25']
    )
    buy_tickets('alice')
    see_tickets('alice')
    print("=========================")
    print("I found no obvious errors")
    print("=========================")


if __name__ == '__main__':
    main()
