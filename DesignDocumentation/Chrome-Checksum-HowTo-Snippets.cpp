/* This file contains snippets of open-source code from The Chromium Project,
 some of which (near the top here) I studied in order to reproduce the way
 Google Chrome computes the checksum of a bookmarks file.

 If the hyperlinks to the original sources still work, you are of course better
 off to visit referenced links because in those source code viewers symbol
 names are hyperlinks which you can click on to jump to definition, etc.
/*

 You can see this not checksumming in the source code…
 https://cs.chromium.org/chromium/src/components/bookmarks/browser/bookmark_codec.cc
 or on the github mirror:
 https://github.com/chromium/chromium/blob/master/components/bookmarks/browser/bookmark_codec.cc
 In this function:
 */
std::unique_ptr<base::Value> BookmarkCodec::Encode(
                                                   const BookmarkNode* bookmark_bar_node,
                                                   const BookmarkNode* other_folder_node,
                                                   const BookmarkNode* mobile_folder_node,
                                                   const BookmarkNode::MetaInfoMap* model_meta_info_map,
                                                   int64_t sync_transaction_version)

/* You will see the following code… */

InitializeChecksum();
DictionaryValue* roots = new DictionaryValue();
roots->Set(kRootFolderNameKey, EncodeNode(bookmark_bar_node));
roots->Set(kOtherBookmarkFolderNameKey, EncodeNode(other_folder_node));
roots->Set(kMobileBookmarkFolderNameKey, EncodeNode(mobile_folder_node));
if (!model_meta_info.empty())
roots->SetString(kMetaInfo, model_meta_info);
DictionaryValue* main = new DictionaryValue();
main->SetInteger(kVersionKey, kCurrentVersion);
FinalizeChecksum();
// We are going to store the computed checksum. So set stored checksum to be
// the same as computed checksum.
stored_checksum_ = computed_checksum_;
main->Set(kChecksumKey, new base::StringValue(computed_checksum_));
main->Set(kRootsKey, roots);

/*
 Jerry's comments:

 The above initializes the checksum, then creates a dictionary called
 'roots'.  Then the three invocations of roots->Set() look like they
 add the Bookmarks Bar, Other Bookmarks and Mobile Bookmarks (aka
 "sync") to the dictionary and also add to the checksum using the
 EncodeNode() function which recursively adds nodes to the
 checksum.  But notice the next line; if model_meta_info is not
 empty it gets set into the 'roots' dictionary, but it does *not*
 get encoded; there is no EncodeNode() in that line.  Finally, a
 'main' dictionary is created, the 'version' is added to it,
 and then the checksum is finalized.  So the checksum only
 includes Bar, Other and Mobile.  Finally, the finalized checksum
 and 'roots' are added to the 'main' dictionary.

 The EncodeNode() function is:
 */

std::unique_ptr<base::Value> BookmarkCodec::EncodeNode(const BookmarkNode* node) {
    std::unique_ptr<base::DictionaryValue> value(new base::DictionaryValue());
    std::string id = base::Int64ToString(node->id());
    value->SetString(kIdKey, id);
    const base::string16& title = node->GetTitle();
    value->SetString(kNameKey, title);
    value->SetString(kDateAddedKey,
                     base::Int64ToString(node->date_added().ToInternalValue()));
    if (node->is_url()) {
        value->SetString(kTypeKey, kTypeURL);
        std::string url = node->url().possibly_invalid_spec();
        value->SetString(kURLKey, url);
        UpdateChecksumWithUrlNode(id, title, url);
    } else {
        value->SetString(kTypeKey, kTypeFolder);
        value->SetString(
                         kDateModifiedKey,
                         base::Int64ToString(node->date_folder_modified().ToInternalValue()));
        UpdateChecksumWithFolderNode(id, title);

        auto child_values = base::MakeUnique<base::ListValue>();
        for (int i = 0; i < node->child_count(); ++i)
            child_values->Append(EncodeNode(node->GetChild(i)));
        value->Set(kChildrenKey, std::move(child_values));
    }
    const BookmarkNode::MetaInfoMap* meta_info_map = node->GetMetaInfoMap();
    if (meta_info_map)
        value->Set(kMetaInfo, EncodeMetaInfo(*meta_info_map));
    if (node->sync_transaction_version() != BookmarkNode::kInvalidSyncTransactionVersion) {
        value->SetString(kSyncTransactionVersion,
                         base::Int64ToString(node->sync_transaction_version()));
    }
    return std::move(value);
}

/* And then we have these */

void BookmarkCodec::UpdateChecksumWithUrlNode(const std::string& id,
                                              const base::string16& title,
                                              const std::string& url) {
    DCHECK(base::IsStringUTF8(url));
    UpdateChecksum(id);
    UpdateChecksum(title);
    UpdateChecksum(kTypeURL);
    UpdateChecksum(url);
}

void BookmarkCodec::UpdateChecksumWithFolderNode(const std::string& id,
                                                 const base::string16& title) {
    UpdateChecksum(id);
    UpdateChecksum(title);
    UpdateChecksum(kTypeFolder);
}

/* Continuing, */

void BookmarkCodec::UpdateChecksum(const std::string& str) {
    base::MD5Update(&md5_context_, str);
}

/* Then, in
 https://cs.chromium.org/chromium/src/base/md5.cc
 we find the MD5Update() function, with comments are from the source code.
 */

/*
 * Update context to reflect the concatenation of another buffer full
 * of bytes.
 */
void MD5Update(MD5Context* context, const StringPiece& data) {
    struct Context* ctx = reinterpret_cast<struct Context*>(context);
    const uint8_t* buf = reinterpret_cast<const uint8_t*>(data.data());
    size_t len = data.size();

    /* Update bitcount */

    uint32_t t = ctx->bits[0];
    if ((ctx->bits[0] = t + (static_cast<uint32_t>(len) << 3)) < t)
        ctx->bits[1]++; /* Carry from low to high */
    ctx->bits[1] += static_cast<uint32_t>(len >> 29);

    t = (t >> 3) & 0x3f; /* Bytes already in shsInfo->data */

    /* Handle any leading odd-sized chunks */

    if (t) {
        uint8_t* p = static_cast<uint8_t*>(ctx->in + t);

        t = 64 - t;
        if (len < t) {
            memcpy(p, buf, len);
            return;
        }
        memcpy(p, buf, t);
        byteReverse(ctx->in, 16);
        MD5Transform(ctx->buf, reinterpret_cast<uint32_t*>(ctx->in));
        buf += t;
        len -= t;
    }

    /* Process data in 64-byte chunks */

    while (len >= 64) {
        memcpy(ctx->in, buf, 64);
        byteReverse(ctx->in, 16);
        MD5Transform(ctx->buf, reinterpret_cast<uint32_t*>(ctx->in));
        buf += 64;
        len -= 64;
    }

    /* Handle any remaining bytes of data. */

    memcpy(ctx->in, buf, len);
}

/* And finally that MD5Transform function, which is the "core", as they say: */

/* The four core functions - F1 is optimized somewhat */

/* #define F1(x, y, z) (x & y | ~x & z) */
#define F1(x, y, z) (z ^ (x & (y ^ z)))
#define F2(x, y, z) F1(z, x, y)
#define F3(x, y, z) (x ^ y ^ z)
#define F4(x, y, z) (y ^ (x | ~z))

/* This is the central step in the MD5 algorithm. */
#define MD5STEP(f, w, x, y, z, data, s) \
(w += f(x, y, z) + data, w = w << s | w >> (32 - s), w += x)

/*
 * The core of the MD5 algorithm, this alters an existing MD5 hash to
 * reflect the addition of 16 longwords of new data.  MD5Update blocks
 * the data and converts bytes into longwords for this routine.
 */
void MD5Transform(uint32_t buf[4], const uint32_t in[16]) {
    uint32_t a, b, c, d;

    a = buf[0];
    b = buf[1];
    c = buf[2];
    d = buf[3];

    MD5STEP(F1, a, b, c, d, in[0] + 0xd76aa478, 7);
    MD5STEP(F1, d, a, b, c, in[1] + 0xe8c7b756, 12);
    MD5STEP(F1, c, d, a, b, in[2] + 0x242070db, 17);
    MD5STEP(F1, b, c, d, a, in[3] + 0xc1bdceee, 22);
    MD5STEP(F1, a, b, c, d, in[4] + 0xf57c0faf, 7);
    MD5STEP(F1, d, a, b, c, in[5] + 0x4787c62a, 12);
    MD5STEP(F1, c, d, a, b, in[6] + 0xa8304613, 17);
    MD5STEP(F1, b, c, d, a, in[7] + 0xfd469501, 22);
    MD5STEP(F1, a, b, c, d, in[8] + 0x698098d8, 7);
    MD5STEP(F1, d, a, b, c, in[9] + 0x8b44f7af, 12);
    MD5STEP(F1, c, d, a, b, in[10] + 0xffff5bb1, 17);
    MD5STEP(F1, b, c, d, a, in[11] + 0x895cd7be, 22);
    MD5STEP(F1, a, b, c, d, in[12] + 0x6b901122, 7);
    MD5STEP(F1, d, a, b, c, in[13] + 0xfd987193, 12);
    MD5STEP(F1, c, d, a, b, in[14] + 0xa679438e, 17);
    MD5STEP(F1, b, c, d, a, in[15] + 0x49b40821, 22);

    MD5STEP(F2, a, b, c, d, in[1] + 0xf61e2562, 5);
    MD5STEP(F2, d, a, b, c, in[6] + 0xc040b340, 9);
    MD5STEP(F2, c, d, a, b, in[11] + 0x265e5a51, 14);
    MD5STEP(F2, b, c, d, a, in[0] + 0xe9b6c7aa, 20);
    MD5STEP(F2, a, b, c, d, in[5] + 0xd62f105d, 5);
    MD5STEP(F2, d, a, b, c, in[10] + 0x02441453, 9);
    MD5STEP(F2, c, d, a, b, in[15] + 0xd8a1e681, 14);
    MD5STEP(F2, b, c, d, a, in[4] + 0xe7d3fbc8, 20);
    MD5STEP(F2, a, b, c, d, in[9] + 0x21e1cde6, 5);
    MD5STEP(F2, d, a, b, c, in[14] + 0xc33707d6, 9);
    MD5STEP(F2, c, d, a, b, in[3] + 0xf4d50d87, 14);
    MD5STEP(F2, b, c, d, a, in[8] + 0x455a14ed, 20);
    MD5STEP(F2, a, b, c, d, in[13] + 0xa9e3e905, 5);
    MD5STEP(F2, d, a, b, c, in[2] + 0xfcefa3f8, 9);
    MD5STEP(F2, c, d, a, b, in[7] + 0x676f02d9, 14);
    MD5STEP(F2, b, c, d, a, in[12] + 0x8d2a4c8a, 20);

    MD5STEP(F3, a, b, c, d, in[5] + 0xfffa3942, 4);
    MD5STEP(F3, d, a, b, c, in[8] + 0x8771f681, 11);
    MD5STEP(F3, c, d, a, b, in[11] + 0x6d9d6122, 16);
    MD5STEP(F3, b, c, d, a, in[14] + 0xfde5380c, 23);
    MD5STEP(F3, a, b, c, d, in[1] + 0xa4beea44, 4);
    MD5STEP(F3, d, a, b, c, in[4] + 0x4bdecfa9, 11);
    MD5STEP(F3, c, d, a, b, in[7] + 0xf6bb4b60, 16);
    MD5STEP(F3, b, c, d, a, in[10] + 0xbebfbc70, 23);
    MD5STEP(F3, a, b, c, d, in[13] + 0x289b7ec6, 4);
    MD5STEP(F3, d, a, b, c, in[0] + 0xeaa127fa, 11);
    MD5STEP(F3, c, d, a, b, in[3] + 0xd4ef3085, 16);
    MD5STEP(F3, b, c, d, a, in[6] + 0x04881d05, 23);
    MD5STEP(F3, a, b, c, d, in[9] + 0xd9d4d039, 4);
    MD5STEP(F3, d, a, b, c, in[12] + 0xe6db99e5, 11);
    MD5STEP(F3, c, d, a, b, in[15] + 0x1fa27cf8, 16);
    MD5STEP(F3, b, c, d, a, in[2] + 0xc4ac5665, 23);

    MD5STEP(F4, a, b, c, d, in[0] + 0xf4292244, 6);
    MD5STEP(F4, d, a, b, c, in[7] + 0x432aff97, 10);
    MD5STEP(F4, c, d, a, b, in[14] + 0xab9423a7, 15);
    MD5STEP(F4, b, c, d, a, in[5] + 0xfc93a039, 21);
    MD5STEP(F4, a, b, c, d, in[12] + 0x655b59c3, 6);
    MD5STEP(F4, d, a, b, c, in[3] + 0x8f0ccc92, 10);
    MD5STEP(F4, c, d, a, b, in[10] + 0xffeff47d, 15);
    MD5STEP(F4, b, c, d, a, in[1] + 0x85845dd1, 21);
    MD5STEP(F4, a, b, c, d, in[8] + 0x6fa87e4f, 6);
    MD5STEP(F4, d, a, b, c, in[15] + 0xfe2ce6e0, 10);
    MD5STEP(F4, c, d, a, b, in[6] + 0xa3014314, 15);
    MD5STEP(F4, b, c, d, a, in[13] + 0x4e0811a1, 21);
    MD5STEP(F4, a, b, c, d, in[4] + 0xf7537e82, 6);
    MD5STEP(F4, d, a, b, c, in[11] + 0xbd3af235, 10);
    MD5STEP(F4, c, d, a, b, in[2] + 0x2ad7d2bb, 15);
    MD5STEP(F4, b, c, d, a, in[9] + 0xeb86d391, 21);

    buf[0] += a;
    buf[1] += b;
    buf[2] += c;
    buf[3] += d;
}

}  // namespace

namespace base {

    /*
     * Start MD5 accumulation.  Set bit count to 0 and buffer to mysterious
     * initialization constants.
     */
    void MD5Init(MD5Context* context) {
        struct Context* ctx = reinterpret_cast<struct Context*>(context);
        ctx->buf[0] = 0x67452301;
        ctx->buf[1] = 0xefcdab89;
        ctx->buf[2] = 0x98badcfe;
        ctx->buf[3] = 0x10325476;
        ctx->bits[0] = 0;
        ctx->bits[1] = 0;
    }

    /*
     * Update context to reflect the concatenation of another buffer full
     * of bytes.
     */
    void MD5Update(MD5Context* context, const StringPiece& data) {
        struct Context* ctx = reinterpret_cast<struct Context*>(context);
        const uint8_t* buf = reinterpret_cast<const uint8_t*>(data.data());
        size_t len = data.size();

        /* Update bitcount */

        uint32_t t = ctx->bits[0];
        if ((ctx->bits[0] = t + (static_cast<uint32_t>(len) << 3)) < t)
            ctx->bits[1]++; /* Carry from low to high */
        ctx->bits[1] += static_cast<uint32_t>(len >> 29);

        t = (t >> 3) & 0x3f; /* Bytes already in shsInfo->data */

        /* Handle any leading odd-sized chunks */

        if (t) {
            uint8_t* p = static_cast<uint8_t*>(ctx->in + t);

            t = 64 - t;
            if (len < t) {
                memcpy(p, buf, len);
                return;
            }
            memcpy(p, buf, t);
            byteReverse(ctx->in, 16);
            MD5Transform(ctx->buf, reinterpret_cast<uint32_t*>(ctx->in));
            buf += t;
            len -= t;
        }

        /* Process data in 64-byte chunks */

        while (len >= 64) {
            memcpy(ctx->in, buf, 64);
            byteReverse(ctx->in, 16);
            MD5Transform(ctx->buf, reinterpret_cast<uint32_t*>(ctx->in));
            buf += 64;
            len -= 64;
        }

        /* Handle any remaining bytes of data. */

        memcpy(ctx->in, buf, len);
    }

    /*
     * Final wrapup - pad to 64-byte boundary with the bit pattern
     * 1 0* (64-bit count of bits processed, MSB-first)
     */
    void MD5Final(MD5Digest* digest, MD5Context* context) {
        struct Context* ctx = reinterpret_cast<struct Context*>(context);
        unsigned count;
        uint8_t* p;

        /* Compute number of bytes mod 64 */
        count = (ctx->bits[0] >> 3) & 0x3F;

        /* Set the first char of padding to 0x80.  This is safe since there is
         always at least one byte free */
        p = ctx->in + count;
        *p++ = 0x80;

        /* Bytes of padding needed to make 64 bytes */
        count = 64 - 1 - count;

        /* Pad out to 56 mod 64 */
        if (count < 8) {
            /* Two lots of padding:  Pad the first block to 64 bytes */
            memset(p, 0, count);
            byteReverse(ctx->in, 16);
            MD5Transform(ctx->buf, reinterpret_cast<uint32_t*>(ctx->in));

            /* Now fill the next block with 56 bytes */
            memset(ctx->in, 0, 56);
        } else {
            /* Pad block to 56 bytes */
            memset(p, 0, count - 8);
        }
        byteReverse(ctx->in, 14);

        /* Append length in bits and transform */
        memcpy(&ctx->in[14 * sizeof(ctx->bits[0])], &ctx->bits[0],
               sizeof(ctx->bits[0]));
        memcpy(&ctx->in[15 * sizeof(ctx->bits[1])], &ctx->bits[1],
               sizeof(ctx->bits[1]));

        MD5Transform(ctx->buf, reinterpret_cast<uint32_t*>(ctx->in));
        byteReverse(reinterpret_cast<uint8_t*>(ctx->buf), 4);
        memcpy(digest->a, ctx->buf, 16);
        memset(ctx, 0, sizeof(*ctx)); /* In case it's sensitive */
    }

    void MD5IntermediateFinal(MD5Digest* digest, const MD5Context* context) {
        /* MD5Final mutates the MD5Context*. Make a copy for generating the
         intermediate value. */
        MD5Context context_copy;
        memcpy(&context_copy, context, sizeof(context_copy));
        MD5Final(digest, &context_copy);
    }

    std::string MD5DigestToBase16(const MD5Digest& digest) {
        static char const zEncode[] = "0123456789abcdef";

        std::string ret;
        ret.resize(32);

        for (int i = 0, j = 0; i < 16; i++, j += 2) {
            uint8_t a = digest.a[i];
            ret[j] = zEncode[(a >> 4) & 0xf];
            ret[j + 1] = zEncode[a & 0xf];
        }
        return ret;
    }

    void MD5Sum(const void* data, size_t length, MD5Digest* digest) {
        MD5Context ctx;
        MD5Init(&ctx);
        MD5Update(&ctx, StringPiece(reinterpret_cast<const char*>(data), length));
        MD5Final(digest, &ctx);
    }

    std::string MD5String(const StringPiece& str) {
        MD5Digest digest;
        MD5Sum(str.data(), str.length(), &digest);
        return MD5DigestToBase16(digest);
    }

}  // namespace base

