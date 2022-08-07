param(
    $File,
    $ParameterNameValueHashtable
)

$XmlConfig = [xml](Get-Content -Path $File)
$ParameterNameValueHashtable.GetEnumerator() | ForEach-Object {
    $Element = $XmlConfig.SelectSingleNode("//Parameter[@Name='$($_.Key)']")
    $Element.Value = $($_.Value)
}
$XmlConfig.Save($File)