/*
Sprinkling of JS to display the correct form fields in real time
*/
class LockForm {
  constructor() {
    this.form = null
    this.feature_selectors = null

    window.addEventListener('load', (_) => this.onLoad())
  }

  onLoad() {
    this.feature_selectors = document.querySelectorAll("input[name='door[feature_flags][]'")

    for (let c of this.feature_selectors) {
      console.log(c)
      c.addEventListener("change", (e) => this.handleFeatureChange(e))
    }
  }

  handleFeatureChange(e) {
    console.log(e)
  }

}

let l = new LockForm()