import { Controller } from "@hotwired/stimulus"
import Rails from '@rails/ujs';

export default class extends Controller {
  static targets = ["suggestions", "vectorSuggestions"]

  #timer = null

  update(e) {
    // Using timer to fire event after 500ms to prevent too many requests.
    if (this.#timer) {
      clearTimeout(this.#timer)
    }

    const target = this.suggestionsTarget
    const vectorTarget = this.vectorSuggestionsTarget
    const query = e.target.value

    this.#timer = setTimeout(() => {
      this.#searchSuggestions(query, target)
      this.#searchSuggestions(query, vectorTarget, 'vector')
    }, 500)
  }

  #searchSuggestions(query, target, vector = false) {
    if (query.length >= 3) {
      Rails.ajax({
        type: 'GET',
        url: '/prompts/search',
        data: new URLSearchParams({
          query: query,
          type: vector ? 'vector' : ''
        }).toString(),
        success: (data) => {
          target.innerHTML = data.length > 0 ? data.map(suggestion =>
            `<li>${suggestion.text} <span class="font-bold">${suggestion.score}</span></li>`
          ).join("") : "No suggestions found."
        },
        error: function(err) {
          console.log(err);
        }
      });
    } else {
      target.innerHTML = "No suggestions found."
    }
  }

}
