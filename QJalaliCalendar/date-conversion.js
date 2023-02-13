.pragma library

function toFarsiNumber(num) {
    return Number(num).toLocaleString(Qt.locale("fa_IR"), 'f', 0).replace(Qt.locale("fa_IR").groupSeparator, "")
}

function fromFarsiNumber(num) {
    return Number.fromLocaleString(Qt.locale("fa_IR"), num)
}

function gregorian_to_jalali(gy, gm, gd) {
    var g_d_m = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    var jy = (gy <= 1600) ? 0 : 979;

    gy -= (gy <= 1600) ? 621 : 1600;

    var gy2 = (gm > 2) ? (gy + 1) : gy;
    var days = (365 * gy) + (parseInt((gy2 + 3) / 4)) - (parseInt((gy2 + 99) / 100)) +
        (parseInt((gy2 + 399) / 400)) - 80 + gd + g_d_m[gm - 1];

    jy += 33 * (parseInt(days / 12053));
    days %= 12053;
    jy += 4 * (parseInt(days / 1461));
    days %= 1461;
    jy += parseInt((days - 1) / 365);

    if (days > 365)
        days = (days - 1) % 365;

    var jm = (days < 186) ? 1 + parseInt(days / 31) : 7 + parseInt((days - 186) / 30);
    var jd = 1 + ((days < 186) ? (days % 31) : ((days - 186) % 30));

    return {"y":jy, "m":jm, "d":jd};
}

function jalali_to_gregorian(jy, jm, jd) {
    var gy = (jy <= 979) ? 621 : 1600;

    jy -= (jy <= 979) ? 0 : 979;

    var days = (365 * jy) + ((parseInt(jy / 33)) * 8) + (parseInt(((jy % 33) + 3) / 4)) +
        78 + jd + ((jm < 7) ? (jm - 1) * 31 : ((jm - 7) * 30) + 186);

    gy += 400 * (parseInt(days / 146097));
    days %= 146097;

    if (days > 36524) {
        gy += 100 * (parseInt(--days / 36524));
        days %= 36524;

        if (days >= 365)
            days++;
    }

    gy += 4 * (parseInt((days) / 1461));
    days %= 1461;
    gy += parseInt((days - 1) / 365);

    if (days > 365)
        days = (days - 1) % 365;

    var gd = days + 1;
    var sal_a = [0, 31, ((gy % 4 == 0 && gy % 100 != 0) || (gy % 400 == 0)) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var gm

    for (gm = 0; gm < 13; gm++) {
        var v = sal_a[gm];
        if (gd <= v) break;
        gd -= v;
    }

    return [gy, gm, gd];
}

function monthName(i) {
    switch (i) {
        case 1:
            return "Farvadin";
        case 2:
            return "Ordibehesht";
        case 3:
            return "Khordad";
        case 4:
            return "Tir";
        case 5:
            return "Mordad";
        case 6:
            return "Shahrivar";
        case 7:
            return "Mehr";
        case 8:
            return "Aban";
        case 9:
            return "Azar";
        case 10:
            return "Dey";
        case 11:
            return "Bahman";
        case 12:
            return "Esfand";
    }
}

function dayName(i) {
    switch (i) {
        case 0:
            return "Sa";
        case 1:
            return "Su";
        case 2:
            return "Mo";
        case 3:
            return "Tu";
        case 4:
            return "We";
        case 5:
            return "Th";
        case 6:
            return "Fr";

    }
}

function dayNumber(jy, jm, jd) {

    var d = jalali_to_gregorian(jy, jm, jd);
    var g = new Date(d[0], d[1] - 1, d[2]).getDay();
    var k = ++g;

    if (k === 7)
        k = 0;

    return k;

}

function dayInMonth(year, month) {
    month = month - 1

    if (month < 0) return -1;
    if (month < 6) return 31;
    if (month < 11) return 30;

    var ary = [1, 5, 9, 13, 17, 22, 26, 30];
    var b = year % 33;

    for (var i = 0; i < ary.length; i++)
        if (b === ary[i])
            return 30;

    return 29;
}

function today() {
    var d = new Date();
    return gregorian_to_jalali(d.getFullYear(), d.getMonth() + 1, d.getDate());
}

function today_jalali_longFormat() {
    var d = new Date();
    var s = gregorian_to_jalali(d.getFullYear(), d.getMonth() + 1, d.getDate());

    var output = dayOfWeek(s.y, s.m, s.d) +
            " " +
            toFarsiNumber(s.d) +
            " " +
            monthName(s.m) +
            " " +
            toFarsiNumber(s.y)

    return output;
}

function dayOfWeek(jy, jm, jd) {
    var d = dayNumber(jy, jm, jd);
    var s = dayName(d);

    return s;
}

