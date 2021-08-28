module("luci.controller.upload.upload", package.seeall)

function index()
    entry({"upload"}, template("upload/upload"),  "Click here", 10).dependent=false
    entry({"upload", "file"},   call("uploadFileTransfer"))
end

function uploadFileTransfer()
    local file_name = luci.http.formvalue('file_name')
    if file_name then
        tmpfile = "/mnt/sda1/" .. file_name[1]
        luci.util.perror(tmpfile)
        local file
        luci.http.setfilehandler(
            function(meta, chunk, eof)
                if not nixio.fs.access(tmpfile) and not file and chunk and #chunk > 0 then
                    file = io.open(tmpfile, "w")
                end
                if file and chunk then
                    file:write(chunk)
                end
                if file and eof then
                    file:close()
                end
            end
        )
     end
end
