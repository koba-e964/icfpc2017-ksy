from server import Server

import sys
import json

# def rotate(l):
#     x = l[-1]
#     a = [x] + l[:-1]
#     return a

def rotate(l):
    x = l[1:]
    x.append(l[0])
    return x

if __name__ == "__main__":
    rounds = int(sys.argv[1])
    mapfile = sys.argv[2]
    commands = sys.argv[3:]
    n = len(commands)

    names = []
    for i in range(n):
        names.append("%s_%d" % (commands[i], i))

    idx = [i for i in range(n)]
    stat = {"punters": [{"name":name, "results":[]} for name in names],
            "rounds": rounds}
    for round in range(rounds):
        server = Server(mapfile, commands, False)
        log = server.run()

        print("round %d:" % (round + 1), file=sys.stderr)
        scores = [(log["scores"][i]["score"], i) for i in range(n)]
        scores.sort()
        scores.reverse()
        for j in range(n):
            i = scores[j][1]
            place = j + 1
            name = names[idx[i]]
            score = scores[j][0]
            result = {"score": scores[j][0], "id": i, "place": place}
            stat["punters"][idx[i]]["results"].append(result)
            print("%d. %s %dpt (id=%d) " % (place, name, score, i), file=sys.stderr)

        commands = rotate(commands)
        idx = rotate(idx)

    for punter in stat["punters"]:
        total = 0.0
        win = 0
        for result in punter["results"]:
            total += result["score"]
            if result["place"] == 1:
                win += 1
        punter["average"] = total / rounds
        punter["win"] = win

    print("result:", file=sys.stderr)
    for punter in stat["punters"]:
        print("%s ave=%fpt win=%d" % (punter["name"], punter["average"], punter["win"]), file=sys.stderr)


    print(json.dumps(stat, separators=(',', ':')))
