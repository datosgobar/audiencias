require 'net/http'
require 'openssl'
require 'json'

class Sintys

  attr_reader :data_error

  def initialize
    @key_path = File.join(Rails.root, 'private', 'key.pem')
    @key_password = SINTYS_CONFIG['key_password']
    @cert_path = File.join(Rails.root, 'private', 'cert.pem')
    @cacert_path = File.join(Rails.root, 'private', 'cacert.pem')
    @port = 20010
    @url = "sews.sintys.gov.ar"

    @organismo = "SRIFDNAC"
    @usuario_organismo = "CHADAD"
    @password = SINTYS_CONFIG['user_password']
    @post_url_sintys = "https://sews.sintys.gov.ar/controlador/POST.server.php"

    @http = Net::HTTP.new(@url, @port)

    set_up_ssl

    @last_response = nil
    @data_error = nil
  end

  def identificar_persona_fisica(tipo_doc, numero_doc)
    tipo_doc_sintys = generar_id_tdoc_sintys(tipo_doc)

    query_params = {
      "organismo" => @organismo,
      "usuarioOrganismo" => @usuario_organismo,
      "password" => @password,
      "operacion" => "identificarPersona",
      "modo" => "json",
      "parametros[ndoc]" => numero_doc,
      "parametros[tdoc]" => tipo_doc_sintys,
      "parametros[deno]" => "",
      "parametros[sexo]" => "",
      "parametros[fnac]" => "",
      "parametros[monto]" => "",
      "parametros[tematicas]" => "SI"
    }

    response = post_sintys(query_params)
    parse_sintys_response(response)
  end

  def identificar_persona_juridica(cuit)
    query_params = {
      "organismo" => @organismo,
      "usuarioOrganismo" => @usuario_organismo,
      "password" => @password,
      "operacion" => "identificarPersonaJuridica",
      "modo" => "json",
      "parametros[cuit]" => cuit,
      "parametros[razonSocial]" => "",
      "parametros[tematicas]" => "SI"
    }

    response = post_sintys(query_params)
    parse_sintys_response(response)
  end

  private

  def generar_id_tdoc_sintys(tipo_doc)
    case tipo_doc
      when :dni
        "1"
      when :lc
        "2"
      when :le
        "3"
      when :pasaporte
        "4"
      when :ci
        "7"
      when :cuit
        "10"
      else
         ""
    end
  end

  def value_or_nil(string)
    if string.empty? then nil else string end
  end

  def last_success?
    @last_response.kind_of?(Net::HTTPSuccess)
  end

  def parse_sintys_response(response)
    json_response = JSON.parse(%{#{response}})
    @data_error = value_or_nil(json_response["error"])
    {
      :results => if (@data_error == nil) then json_response["resultado"] else nil end,
      :errors => @data_error
    }
  end

  def post_request(url, body)
    request = Net::HTTP::Post.new(url, {'Content-Type' =>'application/x-www-form-urlencoded'})
    request.set_form_data(body)
    request
  end

  def post_sintys(params)
    sintys_request = post_request(@post_url_sintys, params)
    @last_response = @http.request(sintys_request)
    if !last_success?
      raise "Fallo en la transmision. Error de conexion a Sintys."
    end
    @last_response.body
  end

  def set_up_ssl
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    @http.key = OpenSSL::PKey::RSA.new(File.read(@key_path), @key_password)
    @http.cert = OpenSSL::X509::Certificate.new(File.read(@cert_path))
    @http.ca_file = @cacert_path
  end

end

=begin
sintis = Sintys.new()
puts "Identificar con DNI anda bien"
puts %{sintis.identificar_persona_fisica(:dni, "34321017")}
puts sintis.identificar_persona_fisica(:dni, "34321017")
puts sintis.data_error
puts

puts "Tambien funciona aunque no se especifique el tipo"
puts %{sintis.identificar_persona_fisica("", "32648724")}
puts sintis.identificar_persona_fisica("", "32648724")
puts sintis.data_error
puts

puts "Si no encuentra el dni devuelve arreglo vacio"
puts %{sintis.identificar_persona_fisica("", "1092732648724")}
puts sintis.identificar_persona_fisica("", "1092732648724")
puts sintis.data_error
puts

puts "Este es el pasaporte de pili, tira error, no acepta letras"
puts %{sintis.identificar_persona_fisica("", "Aaa060656")}
puts sintis.identificar_persona_fisica("", "Aaa060656")
puts sintis.data_error
puts

puts "Este no tira error pero no encuentra a Pili, Pasaporte parece poco confiable, asi que no pondria la opcion"
puts %{sintis.identificar_persona_fisica("", "060656")}
puts sintis.identificar_persona_fisica("", "060656")
puts sintis.data_error
puts

puts "Prueba mecha"
puts %{sintis.identificar_persona_fisica("", "35056714")}
puts sintis.identificar_persona_fisica("", "35056714")
puts sintis.data_error
puts

puts "Prueba Nacho L."
puts %{sintis.identificar_persona_fisica("", "34506128")}
puts sintis.identificar_persona_fisica("", "34506128")
puts sintis.data_error
puts


puts "Prueba Jose"
puts %{sintis.identificar_persona_fisica("", "29520353")}
puts sintis.identificar_persona_fisica("", "29520353")
puts sintis.data_error
puts

puts "Prueba Vlada"
puts %{sintis.identificar_persona_fisica("", "19007186")}
puts sintis.identificar_persona_fisica("", "19007186")
puts sintis.data_error
puts

puts "Vlada con su documento viejo"
puts %{sintis.identificar_persona_fisica("", "93655582")}
puts sintis.identificar_persona_fisica("", "93655582")
puts sintis.data_error
puts

puts "Prueba Nacho H"
puts %{sintis.identificar_persona_fisica("", "35368168")}
puts sintis.identificar_persona_fisica("", "35368168")
puts sintis.data_error
puts

puts "Encuentra los dnis por texto completo, una parte del de nacho no lo encuentra"
puts %{sintis.identificar_persona_fisica("", "3450612")}
puts sintis.identificar_persona_fisica("", "3450612")
puts sintis.data_error
puts

puts "Este es el ciut de coca cola"
puts %{sintis.identificar_persona_juridica("30525390086")}
puts sintis.identificar_persona_juridica("30525390086")
puts sintis.data_error
puts
=end