const checklist = require("./checklist");

const map = {
    "day": 1,
    "month": 30,
    "year": 365,
    "week": 7
}

const name = (i) => i.concept.comment;

checklist.items.forEach(i => {
    i.status.forEach(status => {
        const fromKey = Object.keys(status.from);
        const fromValue = status.from[fromKey];
        const toKey = Object.keys(status.to);
        const toValue = status.to[toKey];
        status.start = fromValue * map[fromKey];
        status.end = toValue * map[toKey];
        //console.log(`${name(i)} ${status.state} from ${fromKey} ${fromValue} start ${status.start} to ${toKey} ${toValue} end ${status.end}`);
    });
});

console.log(JSON.stringify(checklist));

