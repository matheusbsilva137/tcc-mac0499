var Hypher = require('hypher'),
    pattern = require('hyphenation.nb-no'),
    fs = require("fs"),
    text = fs.readFileSync("./dictionary.txt", "utf-8").split("\n")
    filter = process.argv[2] || 'bloom-filter';

function writeToFile(fileName, content) {
    fs.appendFileSync(fileName, content + '\n');
}

function buildFileName(filter) {
    return __dirname + '/experiments/' + filter + '.csv';
}

function buildFileHeader() {
    var header = 'epsilon';
    for (var j = 1; j <= 30; j++) {
        header += ',test-' + j.toString();
    }
    return header;
}

writeToFile(buildFileName(filter), buildFileHeader());
writeToFile(buildFileName('build-' + filter), buildFileHeader());
for (var epsilon = 0.01; epsilon < 0.21; epsilon += 0.01) {
    var h;
    var buildContent = (Math.round(epsilon * 100)).toString();
    for (var i = 0; i < 30; i++) {
        const buildStartTime = new Date();
        h = new Hypher(pattern, epsilon, filter);
        const buildEndTime = new Date();
        var buildTimeDiff = buildEndTime - buildStartTime;
        buildContent += ',' + buildTimeDiff.toString();
    }
    writeToFile(buildFileName('build-' + filter), buildContent);

    var content = (Math.round(epsilon * 100)).toString();
    for (var j = 0; j < 30; j++) {
        const startTime = new Date();
        text.map(function (v) {
            return h.hyphenate(v).join('\u2027');
        });
        const endTime = new Date();

        var timeDiff = endTime - startTime; //in ms
        content += ',' + timeDiff.toString();
    }
    writeToFile(buildFileName(filter), content);
}
