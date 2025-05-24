function copyToClipboard(text) {
  navigator.clipboard.writeText(text).then(() => {
    alert("Copied to clipboard!");
  });
}

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('encode_form').addEventListener('submit', async e => {
    e.preventDefault();
    const url = document.getElementById('url').value;
    const res = await fetch('/api/v1/encode', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ url }),
    });
    const data = await res.json();
    const resultElem = document.getElementById('encode_result');
    const copyBtn = document.getElementById('copy_encode');
    if (res.ok) {
      resultElem.textContent = "Short URL: " + data.short_url;
      copyBtn.style.display = 'inline-block';
      copyBtn.onclick = () => copyToClipboard(data.short_url);
    } else {
      resultElem.textContent = "Error: " + data.error;
      copyBtn.style.display = 'none';
    }
  });

  document.getElementById('decode_form').addEventListener('submit', async e => {
    e.preventDefault();
    const url = document.getElementById('short_url').value;
    const res = await fetch('/api/v1/decode', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ url }),
    });
    const data = await res.json();
    const resultElem = document.getElementById('decode_result');
    const copyBtn = document.getElementById('copy_decode');
    if (res.ok) {
      resultElem.textContent = "Original URL: " + data.original_url;
      copyBtn.style.display = 'inline-block';
      copyBtn.onclick = () => copyToClipboard(data.original_url);
    } else {
      resultElem.textContent = "Error: " + data.error;
      copyBtn.style.display = 'none';
    }
  });
});
