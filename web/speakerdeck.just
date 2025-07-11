pdf-download url:
    #!/usr/bin/env bash
    set -e

    URL="{{url}}"

    # PDFのURLを取得
    echo "🔍 Fetching SpeakerDeck page: $URL"
    pdf_url=$(curl -s "$URL" | \
        grep -o 'https://files\.speakerdeck\.com/presentations/[^"]*\.pdf' | \
        head -1)

    if [ -z "$pdf_url" ]; then
        echo "❌ No PDF URL found in the page"
        exit 1
    fi

    echo "📄 Found PDF URL: $pdf_url"

    # ファイル名を抽出（URLデコードして日本語ファイル名に対応）
    filename=$(basename "$pdf_url" | python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))")

    echo "💾 Downloading: $filename"

    # PDFをダウンロード
    curl -L -o "$filename" "$pdf_url"

    echo "✅ Downloaded: $filename"
