/*
Sprinkling of JS to display the correct form fields in real time
*/
class LockForm {
  constructor() {
    this.form = null
    this.titleName = null
    this.featureSelectors = null

    window.addEventListener('load', (_) => this.onLoad())
  }

  onLoad() {
    // Init checkbox listeners
    this.featureSelectors = document.querySelectorAll("input[name='door[feature_flags][]'")

    for (let c of this.featureSelectors) {
      console.log(c)
      c.addEventListener("change", (e) => this.handleFeatureChange(e))

      // Init layout
      this.renderFormComponents(c.value, c.checked)
    }


    // Update title for a nicer UserX
    document.querySelector("input[name='door[name]'")
      .addEventListener("input", (e) => this.updateTitle(e))
    
    this.titleName = document.querySelector("#title-name")
  }

  updateTitle(e) {
    this.titleName.textContent = e.target.value
  }

  handleFeatureChange(e) {
    this.renderFormComponents(e.target.value, e.target.checked)
  }

  renderFormComponents(value, checked) {
    document.querySelector(`#${value}`)
      .style.display = checked ? 'block' : 'none'
  }
}

let l = new LockForm()