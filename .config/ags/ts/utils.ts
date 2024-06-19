export class ColorIterator {
  idx: number
  arr: string[]

  constructor() {
    this.idx = 0
    this.arr = [
      '#f5bde6',
      '#ee99a0',
      '#f5a97f',
      '#eed49f',
      '#a6da95',
      '#8bd5ca'
    ]
  }

  next() {
    const color = this.arr[this.idx]
    this.idx = this.idx < this.arr.length - 1 ? this.idx + 1 : 0
    return color
  }
}
