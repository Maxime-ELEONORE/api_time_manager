export function isBlank(str) {
    return !str || /^\s*$/.test(str);
}

export function isSameObject(obj1, obj2) {
    return JSON.stringify(obj1) === JSON.stringify(obj2);
}