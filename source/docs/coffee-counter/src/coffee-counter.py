from collections import Counter
import web
import json

coffees = Counter()

class Drink(object):
    def POST(self, user, count):
        coffees[user] += int(count)
        return "{0}'s coffee count is now {1}.\n".format(user, coffees[user])

class Report(object):
    def GET(self):
        return json.dumps(coffees)

def main():
    urls = (
        '/drink/(.*)/(.*)', Drink.__name__,
        '/report', Report.__name__,
    )
    app = web.application(urls, globals())
    app.run()

if __name__ == '__main__':
    main()
