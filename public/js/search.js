document.querySelector('#searchForm').addEventListener('submit', function(e) {
  e.preventDefault();

  var token = document.querySelector('#searchInput').value;

  fetch('/exams/' + token)
    .then(response => {
      if (!response.ok) {
        throw new Error('Exame não encontrado');
      }
      return response.json();
    })
    .then(data => {
      window.location.href = '/exams/' + token + '/data';
    })
    .catch(error => {
      var searchInput = document.querySelector('#searchInput');
      searchInput.placeholder = error.message;
      searchInput.value = '';
      setTimeout(() => {
        searchInput.placeholder = 'Digite seu token';
      }, 3000);
    });
});